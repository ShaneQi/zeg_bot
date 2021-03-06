//
//  ZEGBotPlugin.swift
//  zeg_bot
//
//  Created by Shane Qi on 6/4/16.
//
//

#if os(Linux)
	import SwiftGlibc
#else
	import Darwin
#endif
import ZEGBot
import Foundation

class ZEGBotPlugin {
	
	var bot: ZEGBot
	
	init(bot: ZEGBot) { self.bot = bot }
	
	func smartReply(to receiver: Message, content: Any, type: contentType) {
		
		var sendTo: Sendable = receiver.chat
		if let replyTo = receiver.replyToMessage { sendTo = replyTo }
		switch type {
		case .Text:
			bot.send(message: (content as! String), to: sendTo)
		case .PhotoSize:
			bot.send((content as! PhotoSize), to: sendTo)
		case .Sticker:
			bot.send((content as! Sticker), to: sendTo)
		}
		
	}
	
	func distance(between A: Location, and B: Location) -> Double{
		
		func degreeToRadius(_ degree: Double) -> Double{
			
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

extension PhotoSize {

	init(file_id: String, width: Int, height: Int) {
		self.fileId = file_id
		self.width = width
		self.height = height
		self.fileSize = nil
	}

}

extension Sticker {

	init(file_id: String, width: Int, height: Int) {
		self.fileId = file_id
		self.width = width
		self.height = height
		self.fileSize = nil
		self.thumb = nil
		self.emoji = nil
	}
	
}
