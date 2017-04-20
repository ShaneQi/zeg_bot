//
//  SQLite.swift
//  zeg_bot
//
//  Created by Shane Qi on 2/3/17.
//
//

import SQLite

extension SQLite {

	convenience init(in path: String, managing models: [DatabaseManaged.Type]) throws {
		try self.init(path)
		try execute(statement: "PRAGMA foreign_keys = ON;")
		try execute(statement: "PRAGMA busy_timeout = 3000;")
		try models
			.flatMap({ $0.tableCreatingStatement })
			.forEach({ try execute(statement: $0) })
	}

}

protocol DatabaseManaged {

	static var tableCreatingStatement: [String] { get }

}
