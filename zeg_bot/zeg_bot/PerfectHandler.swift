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
		
		do {
			
			let update = try TelegramDecoder.sharedInstance.decodeUpdate(request.postBodyString)
			
			if update.message?.from?.id == tumei && update.message?.voice != nil {
			
				do {
					
					let sqlite = try SQLite(DB_PATH)
					
					if let message_id = update.message?.message_id, chat_id = update.message?.chat.id, file_id = update.message?.voice?.file_id {
					
						let sql = "INSERT INTO tmvoice(message_id, chat_id, file_id) values (\(message_id), \(chat_id), '\(file_id)');"
						
						try sqlite.execute(sql)
					
					}
					
				} catch let e {
					
					print("\(e)")
					
				}
				
			}

			if let message = update.message {
			
				if let text = message.text {
					
					switch text.uppercaseString {
					
					/* Rules go here (order sensitive). */
					case cuckoo:
						ZEGResponse.sharedInstace.smartReply(to: message, content: text)

					case "/学长":
						ZEGResponse.sharedInstace.smartReply(to: message, content: "눈_눈")
						
					case "/JOY":
						ZEGResponse.sharedInstace.smartReply(to: message, content: joy)
						
					case "/JAKE":
						ZEGResponse.sharedInstace.smartReply(to: message, content: jake)
						
					case "/DUYAOO":
						ZEGResponse.sharedInstace.smartReply(to: message, content: "哎呦喂，不得了了！妖妖灵！")
						
					case "/KR":
						ZEGResponse.sharedInstace.smartReply(to: message, content: kr)
						
					case "#朝君ISTYPING":
						ZEGResponse.sharedInstace.directSend(to: message, content: cjtyping)
						
					case "/TMVOICE":
						do {
							
							let sqlite = try SQLite(DB_PATH)
							try sqlite.forEachRow("SELECT * FROM tmvoice ORDER BY id DESC LIMIT 10;") {
								(statement: SQLiteStmt, i:Int) -> () in
								
								if let chat = update.message?.chat, message_id = Int(statement.columnText(1)), from_chat_id = Int(statement.columnText(2)) {
								
									let message = Message(message_id: message_id, from: nil, date: 0, chat: Chat(id: from_chat_id, type: "", title: nil, username: nil, first_name: nil, last_name: nil), text: nil, reply_to_message: nil, voice: nil)
									
									ZEGResponse.sharedInstace.performForward(to: chat, with: message)
									
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
						break
						
					}
					
					cuckoo = text.uppercaseString
					
				} else {
				
					cuckoo = ""
					
				}
			
			}
			
		} catch let e{
			
			print("\(e)")
			
		}
		
		response.requestCompletedCallback()
		
	}
	
}
