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
		
		do {
			
			let a = try TelegramDecode.sharedInstance.decodeUpdate(request.postBodyString)
			response.appendBodyString("\(a.update_id)")
			
		} catch let error{
			print("\(error)")
		}
		
		
		
		response.requestCompletedCallback()
		
	}
	
}
