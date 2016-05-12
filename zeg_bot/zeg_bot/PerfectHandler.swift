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
	
	func handleRequest(request: WebRequest, response: WebResponse) {
		
		var updateObject: Update
		
		do {
			
			updateObject = try TelegramDecode.sharedInstance.decodeUpdate(request.postBodyString)
			
			if updateObject.message?.text == "/学长" {
			
//				TelegramResponse.sharedInstace.stupidReply()
				
			}
			
//			response.appendBodyString("\(updateObject.update_id)")
			
			response.requestCompletedCallback()
			
		} catch let error{
			
			print("\(error)")
			
		}
		

		
	}
	
}
