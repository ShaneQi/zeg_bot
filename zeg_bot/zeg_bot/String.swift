//
//  String.swift
//  zeg_bot
//
//  Created by Shane Qi on 5/12/16.
//  Copyright © 2016 Shane. All rights reserved.
//

extension String: Sendable {
	
	/* Conform to Sendable. */
	public var method: String {
		return "sendMessage"
	}
	
	public var contentIdentification: [String: String] {
		var content = [String: String]()
		content["text"] = self
		return content
	}
	
}
