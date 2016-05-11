//
//  Message.swift
//  zeg_bot
//
//  Created by Shane Qi on 5/10/16.
//  Copyright © 2016 Shane. All rights reserved.
//

public class Message {
	
	var message_id: Int
	var date: Int
	var chat: Chat
	
	/* Optional. */
	var text: String?
	
	init(message_id: Int,
	     date: Int,
	     chat: Chat,
	     text: String?) {
		
		self.message_id = message_id
		self.date = date
		self.chat = chat
		self.text = text
		
	}
}
