//
//  Sendable.swift
//  zeg_bot
//
//  Created by Shane Qi on 5/11/16.
//  Copyright © 2016 Shane. All rights reserved.
//

public protocol Sendable {
	
	var method: String { get }
	var contentIdentification: [String: String]  { get }
	
}
