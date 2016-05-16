//
//  TelegramDecoderError.swift
//  zeg_bot
//
//  Created by Shane Qi on 5/10/16.
//  Copyright © 2016 Shane. All rights reserved.
//

public enum TelegramDecoderError: ErrorType {
	
	/* Request doesn't conform to format. */
	case BadRequest(String)
	
}