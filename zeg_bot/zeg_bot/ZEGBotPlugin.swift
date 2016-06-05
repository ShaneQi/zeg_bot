//
//  ZEGBotPlugin.swift
//  zeg_bot
//
//  Created by Shane Qi on 6/4/16.
//  Copyright © 2016 Shane. All rights reserved.
//

#if os(Linux)
	import SwiftGlibc
#else
	import Darwin
#endif

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
	
	static func distance(between A: Location, and B: Location) -> Double{
		
		func degreeToRadius(degree: Double) -> Double{
			
			let radius: Double = degree * 3.1415926 / 180
			return radius
			
		}
		
		let latA = A.latitude
		let lonA = A.longitude
		let latB = B.latitude
		let lonB = B.longitude
		let R: Double = 3956
		
		let degreeLat = degreeToRadius((latA - latB))
		let degreeLon = degreeToRadius((lonA - lonB))
		
		let a = sin(degreeLat/2) * sin(degreeLat/2) +
			cos(degreeToRadius(latA)) * cos(degreeToRadius(latB)) *
			sin(degreeLon/2) * sin(degreeLon/2)
		
		let c = atan2(sqrt(a), sqrt(1 - a)) * 2
		return R * c
		
	}
	
	
}

enum contentType {

	case Text
	case PhotoSize
	case Sticker

}