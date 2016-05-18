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

			if let message = update.message {
				
				if message.from?.id == tumei && message.voice != nil {
					
					do {
						
						let sqlite = try SQLite(DB_PATH)
						
						let sql = "INSERT INTO tmvoice(update_string) values ('\(request.postBodyString)');"
						
						try sqlite.execute(sql)
						
						// Dev mode feedback.
						if case 1 = mode {
							
							ZEGResponse.sharedInstace.stupidReply(to: update.message!, content: "嗯～")
							
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
							try sqlite.forEachRow("SELECT * FROM tmvoice ORDER BY id ASC LIMIT 10;") {
								(statement: SQLiteStmt, i:Int) -> () in
								
								if let chat = update.message?.chat {
								
									do {
										
										let fetchedUpdateObject = try TelegramDecoder.sharedInstance.decodeUpdate(statement.columnText(1))
										
										if let fetchedMessage = fetchedUpdateObject.message {
										
											ZEGResponse.sharedInstace.performForward(to: chat, with: fetchedMessage)
										
										}
										
									} catch let e {
										
										print("\(e)")
									}
									
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
					
						ZEGResponse.sharedInstace.directSend(to: message, content: text)
						cuckoo = ""
					
					} else {
					
						cuckoo = text
						
					}
					
					
				}
			
			}
			
		} catch let e {
			
			print("\(e)")
			
		}
		
		response.requestCompletedCallback()
		
	}
	
}
