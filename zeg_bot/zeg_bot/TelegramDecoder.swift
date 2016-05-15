//
//  TelegramDecoder.swift
//  zeg_bot
//
//  Created by Shane Qi on 5/10/16.
//  Copyright © 2016 Shane. All rights reserved.
//

import PerfectLib

public class TelegramDecoder {
	
	/* Singleton. */
	static let sharedInstance = TelegramDecoder()
	
	/* Shared JSONDecoder instance. */
	
//	let jsonDecoder = JSONDecoder()
	let jsonDecoder = MutatedJSONDecoder()
	
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
		
//		/* OPTIONAL - inline_query. */
//		var inline_query: InlineQuery?
//		
//		/* OPTIONAL - chosen_inline_result. */
//		var chosen_inline_result: ChosenInlineResult?
//		
//		/* OPTIONAL - callback_query. */
//		var callback_query: CallbackQuery?
		
		return Update(update_id: update_id, message: message
//			, inline_query: inline_query, chosen_inline_result: chosen_inline_result, callback_query: callback_query
		)
		
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
		var chat: Chat
		do {
		
			chat = try decodeChat(jsonDictionary["chat"])
			
		} catch let e {
			
			throw e
		
		}
		
		/* OPTIONAL - text. */
		var text: String?
		
		if let textValue = jsonDictionary["text"] as? String {
			
			text = textValue
			
		} else {
			
			text = nil
			
		}
		
		/* OPTIONAL - reply_to_message. */
		var reply_to_message: Message?
		do {
			
			reply_to_message = try decodeMessage(jsonDictionary["reply_to_message"])
			
		} catch {
			
			reply_to_message = nil
			
		}
		
		return Message(message_id: message_id, date: date, chat: chat, text: text, reply_to_message: reply_to_message)
		
	}
	
	/* Decode JSON String to Chat instance. */
	public func decodeChat(jsonString: String) throws -> Chat {
		
		var jsonValue: JSONValue
		
		/* Decode to JSONValue */
		do {
			
			jsonValue = try jsonDecoder.decode(jsonString)
			
		} catch let e {
			
			throw e
			
		}
		
		/* Call JSONValue decoder. */
		do {
			
			return try decodeChat(jsonValue)
			
		} catch let e {
			
			throw e
			
		}
		
	}
	
	/* Decode JSONValue to Message instance. */
	public func decodeChat(jsonValue: JSONValue) throws -> Chat {
		
		guard (jsonValue is JSONDictionaryType) else {
			
			throw JSONError.UnhandledType("Request body is not JSONDictionaryType.")
			
		}
		
		let jsonDictionary = jsonValue as! JSONDictionaryType
		
		/* id */
		guard let id = jsonDictionary["id"] as? Int else {
			
			throw TelegramDecoderError.BadRequest("Field 'id' is not Int.")
			
		}
		
		/* type */
		guard let type = jsonDictionary["type"] as? String else {
			
			throw TelegramDecoderError.BadRequest("Field 'type' is not String.")
			
		}
		
		/* OPTIONAL - title. */
		var title: String?
		
		if let titleValue = jsonDictionary["title"] as? String {
			
			title = titleValue
			
		} else {
			
			title = nil
			
		}
		
		/* OPTIONAL - username. */
		var username: String?
		
		if let usernameValue = jsonDictionary["username"] as? String {
			
			username = usernameValue
			
		} else {
			
			username = nil
			
		}
		
		/* OPTIONAL - first_name. */
		var first_name: String?
		
		if let first_nameValue = jsonDictionary["first_name"] as? String {
			
			first_name = first_nameValue
			
		} else {
			
			first_name = nil
			
		}
		
		/* OPTIONAL - last_name. */
		var last_name: String?
		
		if let last_nameValue = jsonDictionary["last_name"] as? String {
			
			last_name = last_nameValue
			
		} else {
			
			last_name = nil
			
		}
		
		return Chat(id: id, type: type, title: title, username: username, first_name: first_name, last_name: last_name)
		
	}
	
}
