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
