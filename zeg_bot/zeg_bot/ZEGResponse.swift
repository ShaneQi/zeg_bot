//
//  TelegramResponse.swift
//  zeg_bot
//
//  Created by Shane Qi on 5/11/16.
//  Copyright © 2016 Shane. All rights reserved.
//

import PerfectLib

public class ZEGResponse {

	static let sharedInstace = ZEGResponse()
	
	private var cUrl = CURL()
	
	private var urlPrefix = "https://api.telegram.org/bot"+token+"/"
	
	public func smartReply(to message: Message, content: Sendable) {
	
		if let reply_to_message = message.reply_to_message {
		
			performReponse(reply_to_message, content: content)
		
		} else {
		
			performReponse(message.chat, content: content)
		
		}
		
	}
	
	public func directSend(to message: Message, content: Sendable) {
	
		performReponse(message.chat, content: content)
		
	}
	
	private func performReponse(recipient: Receivable, content: Sendable) {
		
		var url = urlPrefix+content.method+"?"
		
		for field in recipient.recipientIdentification {
			
			url += field.0+"="+field.1+"&"
			
		}
		
		for field in content.contentIdentification {
			
			url += field.0+"="+field.1+"&"
			
		}
		
		cUrl.url = url
		cUrl.performFully()
		
	}

}
