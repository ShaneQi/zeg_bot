//
//  PerfectInit.swift
//  zeg_bot
//
//  Created by Shane Qi on 5/9/16.
//  Copyright © 2016 Shane. All rights reserved.
//


import PerfectLib

public func PerfectServerModuleInit() {
	
	Routing.Handler.registerGlobally()
	
	Routing.Routes["POST", ["/", "index.html"] ] = { _ in return ZEGHandler.sharedInstance }
	
	// Check the console to see the logical structure of what was installed.
	print("\(Routing.Routes.description)")
}