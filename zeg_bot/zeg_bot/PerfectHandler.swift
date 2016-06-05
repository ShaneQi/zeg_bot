//
//  PerfectHandler.swift
//  zeg_bot
//
//  Created by Shane Qi on 5/9/16.
//  Copyright © 2016 Shane. All rights reserved.
//

import PerfectLib

class ZEGHandler: RequestHandler {
	
	static let sharedInstance = ZEGHandler()
	
	private var cuckoo = ""
	
	private var mode = 0
	
	func handleRequest(request: WebRequest, response: WebResponse) {
		
		if case 1 = mode {
			
			print(request.postBodyString)
			
		}
		
		
		let update = ZEGDecoder.decodeUpdate(request.postBodyString)
		
		if let message = update?.message {
			
			if let locationA = message.location, locationB = message.reply_to_message?.location , userB = message.reply_to_message?.from?.first_name{
				
				let distance = Int(ZEGBotPlugin.distance(between: locationA, and: locationB))
				
				ZEGResponse.sendMessage(to: message, text: "\(userB) is *\(distance)* miles away from you.", parse_mode: .Markdown, disable_web_page_preview: nil, disable_notification: nil)
				
			}
			
			if message.from?.id == tumei && message.voice != nil {
				
				do {
					
					let sqlite = try SQLite(DB_PATH)
					
					let sql = "INSERT INTO tmvoice(update_string) values ('\(request.postBodyString)');"
					
					try sqlite.execute(sql)
					
					// Dev mode feedback.
					if case 1 = mode {

						ZEGResponse.sendMessage(to: (update?.message)!, text: "嗯～", parse_mode: nil, disable_web_page_preview: nil, disable_notification: true)
						
					}
					
				} catch let e {
					
					print("\(e)")
					
				}
				
			}
		
			if let text = message.text {
				
				var isCommand = true
				
				switch text.uppercaseString {
				
				/* Rules go here (order sensitive). */
				case "/学长":
					ZEGBotPlugin.smartReply(to: message, content: "눈_눈", type: .Text)
					
				case "/JOY":
					ZEGBotPlugin.smartReply(to: message, content: joy, type: .PhotoSize)
					
				case "/JAKE":
					ZEGBotPlugin.smartReply(to: message, content: jake, type: .PhotoSize)
					
				case "/DUYAOO":
					ZEGBotPlugin.smartReply(to: message, content: "哎呦喂，不得了了！妖妖灵！", type: .Text)
					
				case "/KR":
					ZEGBotPlugin.smartReply(to: message, content: kr, type: .Sticker)
					
				case "#朝君ISTYPING":
					ZEGResponse.sendSticker(to: message.chat, sticker: cjtyping, disable_notification: nil)
					
				case "/TAO":
					ZEGResponse.sendPhoto(to: message.chat, photo: tao, caption: nil, disable_notification: nil)
					
				case "/TMVOICE":
					do {
						
						let sqlite = try SQLite(DB_PATH)
						
						var messageQueue = [Message]()
						
						try sqlite.forEachRow("SELECT * FROM tmvoice ORDER BY id DESC LIMIT 5;") {
							(statement: SQLiteStmt, i:Int) -> () in
							
								
							let fetchedUpdateObject = ZEGDecoder.decodeUpdate(statement.columnText(1))
							
							if let fetchedMessage = fetchedUpdateObject?.message {
							
								messageQueue.append(fetchedMessage)
							
							}
						
							
						}
						
						if let chat = update?.message?.chat {
							
							while messageQueue.count != 0 {
								
								ZEGResponse.forwardMessage(to: chat, message: messageQueue.popLast()!, disable_notification: nil)
								
							}
							
						}
						
						
					} catch let e {
						
						print("\(e)")
						
					}
					
				case "/WHOSYOURDADDY":
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
				
					ZEGResponse.sendMessage(to: message.chat, text: "*\(text)*", parse_mode: .Markdown, disable_web_page_preview: nil, disable_notification: nil)
					cuckoo = ""
				
				} else {
				
					cuckoo = text
					
				}
				
				
			}
		
		}
		
		response.requestCompletedCallback()

	}
}
