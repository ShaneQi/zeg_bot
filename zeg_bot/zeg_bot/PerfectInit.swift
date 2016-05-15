//
//  PerfectInit.swift
//  zeg_bot
//
//  Created by Shane Qi on 5/9/16.
//  Copyright © 2016 Shane. All rights reserved.
//


import PerfectLib

let DB_PATH = PerfectServer.staticPerfectServer.homeDir() + serverSQLiteDBs + "tmvoice"

public func PerfectServerModuleInit() {
	
	Routing.Handler.registerGlobally()
	
	Routing.Routes["POST", ["/", "index.html"] ] = { _ in return ZEGHandler.sharedInstance }
	
	// Check the console to see the logical structure of what was installed.
	print("\(Routing.Routes.description)")
	
	do {
		
		let sqlite = try SQLite(DB_PATH)
		try sqlite.execute("CREATE TABLE IF NOT EXISTS tmvoice (id INTEGER PRIMARY KEY AUTOINCREMENT, message_id INTEGER ,chat_id INTEGER ,file_id TEXT)")
		
	} catch {
		
		print("Failure creating database at " + DB_PATH)
		
	}
	
}