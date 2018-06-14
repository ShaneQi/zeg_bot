//
//  main.swift
//  zeg_bot
//
//  Created by Shane Qi on 6/4/16.
//
//

import ZEGBot
import Foundation

let bot = ZEGBot(token: secret)
let plugin = ZEGBotPlugin(bot: bot)

var cuckoo = ""
var mode = 0
var lastJobsCheckingDay = 0

bot.run { update, bot in

	if case 1 = mode { print(update) }

	if case .success(let update) = update,
		let message = update.message {

		if let photo = message.photo?.last,
			case .success(let file) = bot.getFile(ofId: photo.fileId),
			let filePath = file.filePath {
			let fileUrl = "\"https://api.telegram.org/file/bot\(secret)/\(filePath)\""
			var request = URLRequest(url: URL(string: "https://api.algorithmia.com/v1/algo/opencv/FaceDetectionBox/0.1.1")!)
			request.httpMethod = "POST"
			request.httpBody = fileUrl.data(using: .utf8)
			request.addValue("application/json", forHTTPHeaderField: "Content-Type")
			request.addValue("Simple \(algorithmiaApiKey)", forHTTPHeaderField: "Authorization")
			URLSession(configuration: .default).dataTask(with: request) { data, _, _ in
				guard let data = data else { return }
				let response = try? JSONDecoder().decode(FaceDetectionBoxResponse.self, from: data)
				let hasFace = (response?.result.isEmpty == false)
				let fileName = "\(message.messageId).jpg"
				var fileSaveRelativePath = "photos/"
				if hasFace { fileSaveRelativePath += "faces/" }
				let fileObsolutePath = filesPath + fileSaveRelativePath
				do {
					if !FileManager.default.fileExists(atPath: fileObsolutePath) {
						try FileManager.default.createDirectory(atPath: fileObsolutePath, withIntermediateDirectories: true)
					}
					let request = URLRequest(url: URL(string: "https://api.telegram.org/file/bot\(secret)/" + filePath)!)
					URLSession(configuration: .default).dataTask(with: request) { data, _, _ in
						do {
							guard let data = data else { return }
							let url = URL(fileURLWithPath: fileObsolutePath + fileName)
							try data.write(to: url)
							if hasFace { bot.send(message: "Gotcha!", to: message) }
						} catch(let error) {
							bot.send(message: "Failed to save file to \(fileObsolutePath + fileName), because \(error).", to: shaneChat)
						}
						}.resume()
				} catch(let error) {
					bot.send(message: "Failed to save file to \(fileObsolutePath + fileName), because \(error).", to: shaneChat)
				}
				}.resume()
		}

		if let locationA = message.location,
			let locationB = message.replyToMessage?.location,
			let userB = message.replyToMessage?.from?.firstName {

			let distance = Int(plugin.distance(between: locationA, and: locationB))

			let _ = bot.send(message: "\(userB) is *\(distance)* miles away from you.", to: message)

		}

		if let text = message.text {

			var isCommand = true

			switch text.uppercased() {

				/* Rules go here (order sensitive). */
			case "/学长", "/学长@ZEG_BOT":
				plugin.smartReply(to: message, content: "눈_눈", type: .Text)

			case "/JOY", "/JOY@ZEG_BOT":
				plugin.smartReply(to: message, content: joy, type: .PhotoSize)

			case "/JAKE", "/JAKE@ZEG_BOT":
				plugin.smartReply(to: message, content: jake, type: .PhotoSize)

			case "/DUYAOO", "/DUYAOO@ZEG_BOT":
				plugin.smartReply(to: message, content: "哎呦喂，不得了了！妖妖灵！", type: .Text)

			case "/KR", "/KR@ZEG_BOT":
				plugin.smartReply(to: message, content: kr, type: .Sticker)

			case "#朝君ISTYPING":
				let _ = bot.send(cjtyping, to: message.chat)

			case "/WHOSYOURDADDY":
				guard message.from?.id == shane else { break }
				mode = (mode + 1) % 2
				if mode == 1 { print("Switched to dev mode.") }
				else { print("Switched to normal mode.") }

			default:
				isCommand = false
				break

			}

			if isCommand {

				cuckoo = ""

			} else if text == cuckoo {

				bot.send(message: "*\(text)*", to: message.chat, parseMode: .markdown)
				cuckoo = ""
				
			} else {
				
				cuckoo = text
				
			}
			
		}
		
	}
}
