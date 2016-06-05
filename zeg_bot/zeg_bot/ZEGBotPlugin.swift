//
//  ZEGBotPlugin.swift
//  zeg_bot
//
//  Created by Shane Qi on 6/4/16.
//  Copyright © 2016 Shane. All rights reserved.
//

class ZEGBotPlugin {
	
	static func smartReply(to receiver: Message, content: Any, type: contentType) {
	
		var sendTo: Receivable = receiver.chat
		if let replyTo = receiver.reply_to_message { sendTo = replyTo }
		switch type {
		case .Text:
			ZEGResponse.sendMessage(to: sendTo, text: (content as! String), parse_mode: nil, disable_web_page_preview: nil, disable_notification: nil)
		case .PhotoSize:
			ZEGResponse.sendPhoto(to: sendTo, photo: (content as! PhotoSize), caption: nil, disable_notification: nil)
		case .Sticker:
			ZEGResponse.sendSticker(to: sendTo, sticker: (content as! Sticker), disable_notification: nil)
		}
		
	}
	
	
}

enum contentType {

	case Text
	case PhotoSize
	case Sticker

}