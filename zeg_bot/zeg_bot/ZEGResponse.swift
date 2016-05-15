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
		
			performSend(reply_to_message, content: content)
		
		} else {
		
			performSend(message.chat, content: content)
		
		}
		
	}
	
	public func directSend(to message: Message, content: Sendable) {
	
		performSend(message.chat, content: content)
		
	}
	
	public func performForward(to chat: Chat, with message: Forwardable)  {
		
		cUrl.url = urlGenerator(urlPrefix, method: "forwardMessage", parameters: [message.forwardIdentification, chat.recipientIdentification])
		
		cUrl.performFully()
	
	}
	
	private func performSend(recipient: Receivable, content: Sendable) {
		
		cUrl.url = urlGenerator(urlPrefix, method: content.method, parameters: [recipient.recipientIdentification, content.contentIdentification])
		
		cUrl.performFully()
		
	}
	
	private func urlGenerator(url: String, method: String, parameters: [[String: String]]) -> String{
	
		var urlResult = url+method+"?"
		
		for dict in parameters {
			
			for field in dict {
				
				urlResult += field.0+"="+field.1+"&"
				
			}
		
		}

		return urlResult
		
	}

}
