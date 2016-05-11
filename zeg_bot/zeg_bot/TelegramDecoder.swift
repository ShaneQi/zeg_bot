//
//  JSONDecoder.swift
//  zeg_bot
//
//  Created by Shane Qi on 5/10/16.
//  Copyright © 2016 Shane. All rights reserved.
//

import PerfectLib

public class TelegramDecode: JSONDecoder {
	
	/* Singleton. */
	static let sharedInstance = TelegramDecode()
	
	/* Shared JSONDecoder instance. */
	let jsonDecoder = JSONDecoder()
	
	/* Decode JSON String to Update instance. */
	public func decodeUpdate(jsonString: String) throws -> Update {
	
		var jsonValue: JSONValue
		
		/* Decode to JSONValue */
		do {
			
			jsonValue = try jsonDecoder.decode(jsonString)
			
		} catch let e {
			
			throw e
			
		}
		
		/* Call JSONValue decoder. */
		do {
		
			return try decodeUpdate(jsonValue)
			
		} catch let e {
		
			throw e
			
		}
		
	}
	
	/* Decode JSONValue to Update instance. */
	public func decodeUpdate(jsonValue: JSONValue) throws -> Update {
		
		guard (jsonValue is JSONDictionaryType) else {

			throw JSONError.UnhandledType("Request body is not JSONDictionaryType.")
			
		}
		
		let jsonDictionary = jsonValue as! JSONDictionaryType
		
		/* update_id. */
		guard let update_id = jsonDictionary["update_id"] as? Int else {
		
			throw TelegramDecoderError.BadRequest("Field 'update_id' is not Int.")
			
		}
		
		/* OPTIONAL - message. */
		var message: Message?
		
		do {
		
			message = try decodeMessage(jsonDictionary["message"])
			
		} catch {
		
			message = nil
			
		}
		
		/* OPTIONAL - inline_query. */
		var inline_query: InlineQuery?
		
		/* OPTIONAL - chosen_inline_result. */
		var chosen_inline_result: ChosenInlineResult?
		
		/* OPTIONAL - callback_query. */
		var callback_query: CallbackQuery?
		
		return Update(update_id: update_id, message: message, inline_query: inline_query, chosen_inline_result: chosen_inline_result, callback_query: callback_query)
		
	}
	
	/* Decode JSON String to Message instance. */
	public func decodeMessage(jsonString: String) throws -> Message {
		
		var jsonValue: JSONValue
		
		/* Decode to JSONValue */
		do {
			
			jsonValue = try jsonDecoder.decode(jsonString)
			
		} catch let e {
			
			throw e
			
		}
		
		/* Call JSONValue decoder. */
		do {
			
			return try decodeMessage(jsonValue)
			
		} catch let e {
			
			throw e
			
		}
		
	}
	
	/* Decode JSONValue to Message instance. */
	public func decodeMessage(jsonValue: JSONValue) throws -> Message {
		
		guard (jsonValue is JSONDictionaryType) else {
			
			throw JSONError.UnhandledType("Request body is not JSONDictionaryType.")
			
		}
		
		let jsonDictionary = jsonValue as! JSONDictionaryType
		
		/* message_id. */
		guard let message_id = jsonDictionary["message_id"] as? Int else {
			
			throw TelegramDecoderError.BadRequest("Field 'message_id' is not Int.")
			
		}
		
		/* date. */
		guard let date = jsonDictionary["date"] as? Int else {
			
			throw TelegramDecoderError.BadRequest("Field 'date' is not Int.")
			
		}
		
		/* chat. */
		guard let chat = jsonDictionary["chat"] as? JSONValue else {
			
			throw TelegramDecoderError.BadRequest("Field 'chat' is not JSONValue.")
			
		}
		
		/* OPTIONAL - text. */
		var text: String?
		
		if let textValue = jsonDictionary["text"] as? String {
			
			text = textValue
			
		} else {
			
			text = nil
			
		}
		
		return Message(message_id: message_id, date: date, chat: Chat(), text: text)
		
	}
	
}
