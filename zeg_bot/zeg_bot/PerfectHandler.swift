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
	
	func handleRequest(request: WebRequest, response: WebResponse) {
		
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
						
					default:
						break
						
					}
					
					cuckoo = text.uppercaseString
					
				}
			
			}
			
		} catch let e{
			
			print("\(e)")
			
		}
		
		response.requestCompletedCallback()
		
	}
	
}
