//
//  TelegramResponse.swift
//  zeg_bot
//
//  Created by Shane Qi on 5/11/16.
//  Copyright © 2016 Shane. All rights reserved.
//

import PerfectLib

public class TelegramResponse {

	static let sharedInstace = TelegramResponse()
	
	private var cUrl: CURL!
	
	func stupidReply() {
		
		cUrl = CURL(url: "https://api.telegram.org/bot"+token+"/sendMessage?chat_id=80548625&text=눈_눈")
		cUrl.performFully()
		
	}

}
