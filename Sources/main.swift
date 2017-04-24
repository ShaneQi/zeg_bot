import ZEGBot
import SQLite
import PerfectCURL
import cURL
import Foundation
import SwiftyJSON
import PerfectLib

let bot = ZEGBot(token: secret)
let db = try! SQLite.init(in: "./zeg_bot.db",
                          managing: [Post.self])

var cuckoo = ""
var mode = 0

bot.run { update, bot in

	let plugin = ZEGBotPlugin(bot: bot)

	if case 1 = mode { print(update) }

	if let message = update.message {

		if let photo = message.photo?.last,
			let filePath = bot.getFile(ofId: photo.file_id)?.filePath {
			let fileUrl = "\"https://api.telegram.org/file/bot\(secret)/\(filePath)\""
			var fileUrlBytes = [UInt8](fileUrl.utf8)
			let faceDetectionCurl = CURL()
			faceDetectionCurl.url = "https://api.algorithmia.com/v1/algo/opencv/FaceDetectionBox/0.1.1"
			faceDetectionCurl.setOption(CURLOPT_POSTFIELDS, v: &fileUrlBytes)
			faceDetectionCurl.setOption(CURLOPT_HTTPHEADER, s: "Content-Type: application/json")
			faceDetectionCurl.setOption(CURLOPT_HTTPHEADER, s: "Authorization: Simple \(algorithmiaApiKey)")
			let json = JSON(data: Data(bytes: faceDetectionCurl.performFully().2))
			let hasFace = !json["result"].arrayValue.isEmpty
			var fileName = "\(message.message_id)"
			if let extensionCharacters = filePath.characters.split(separator: ".").last {
				fileName += ".\(String(extensionCharacters))"
			}
			var fileSavePath = filesPath + "photos/"
			if hasFace { fileSavePath += "faces/" }
			let dir = Dir(fileSavePath)
			do {
				if !dir.exists { try dir.create() }
				let file = PerfectLib.File(fileSavePath + fileName)
				let downloadFileCurl = CURL()
				downloadFileCurl.url = "https://api.telegram.org/file/bot\(secret)/" + filePath
				try file.open(.readWrite)
				let _ = try file.write(bytes: downloadFileCurl.performFully().2)
				file.close()
				if hasFace { bot.send(message: "Gotcha!", to: message) }
			} catch(let error) {
				Log.error(message: "Failed to save file to \(fileSavePath + fileName), because \(error).")
			}
		}

		if let senderId = message.from?.id {
			let post = Post(uid: message.message_id,
			                content: message.text ?? "[attachment]",
			                senderId: senderId,
			                updatedAt: message.date,
			                parentUid: message.reply_to_message?.message_id,
			                children: nil)
			do { try post.replace(into: db) } catch { print("error:") }
		}

		if let locationA = message.location,
			let locationB = message.reply_to_message?.location,
			let userB = message.reply_to_message?.from?.first_name {

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
				let _ = bot.send(sticker: cjtyping, to: message.chat)

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

				bot.send(message: "*\(text)*", to: message.chat, parseMode: .MARKDOWN)
				cuckoo = ""

			} else {

				cuckoo = text

			}
			
		}
		
	}
}
