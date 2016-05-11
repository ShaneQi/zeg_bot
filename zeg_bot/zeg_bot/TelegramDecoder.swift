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
		
		if let messageJson = jsonDictionary["message"] {
			
			print("TBI!")
			
		} else {
		
			message = nil
			
		}
		
		/* OPTIONAL - inline_query. */
		var inline_query: InlineQuery?
		
		if let inline_query = jsonDictionary["inline_query"] {
			
			print("TBI!")
			
		} else {
			
			inline_query = nil
			
		}
		
		/* OPTIONAL - chosen_inline_result. */
		var chosen_inline_result: ChosenInlineResult?
		
		if let chosen_inline_result = jsonDictionary["chosen_inline_result"] {
			
			print("TBI!")
			
		} else {
			
			chosen_inline_result = nil
			
		}
		
		/* OPTIONAL - callback_query. */
		var callback_query: CallbackQuery?
		
		if let callback_query = jsonDictionary["callback_query"] {
			
			print("TBI!")
			
		} else {
			
			callback_query = nil
			
		}
		
		return Update(update_id: update_id, message: message, inline_query: inline_query, chosen_inline_result: chosen_inline_result, callback_query: callback_query)
		
	}
	
}
