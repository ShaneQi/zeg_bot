//
//  Message.swift
//  zeg_bot
//
//  Created by Shane Qi on 5/10/16.
//  Copyright © 2016 Shane. All rights reserved.
//

public class Message: Receivable {
	
	var message_id: Int
	var date: Int
	var chat: Chat
	
	/* Optional. */
	var from: User?
	var text: String?
	var reply_to_message: Message?
	var voice: Voice?
	
	init(message_id: Int,
	     from: User?,
	     date: Int,
	     chat: Chat,
	     text: String?,
	     reply_to_message: Message?,
	     voice: Voice?) {
		
		self.message_id = message_id
		self.from = from
		self.date = date
		self.chat = chat
		self.text = text
		self.reply_to_message = reply_to_message
		self.voice = voice

	}
	
	/* Conform to Receivable. */
	lazy public var recipientIdentification: [String : String] = {
		
		var recipientIdentification = [String : String]()
		recipientIdentification["chat_id"] = "\(self.chat.id)"
		recipientIdentification["reply_to_message_id"] = "\(self.message_id)"
		return recipientIdentification
		
	} ()
	
}