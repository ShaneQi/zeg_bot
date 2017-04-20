//
//  Model.swift
//  zeg_bot
//
//  Created by Shane Qi on 4/20/17.
//
//

import SQLite

struct Post: DatabaseManaged {

	static var tableCreatingStatement: [String] = [
		"CREATE TABLE IF NOT EXISTS `posts` (" +
			"`uid` INTEGER NOT NULL UNIQUE," +
			"`content` TEXT NOT NULL," +
			"`sender_id` INTEGER NOT NULL," +
			"`updated_at` INTEGER NOT NULL," +
			"PRIMARY KEY(`uid`)" +
		");",
		"CREATE TABLE IF NOT EXISTS `post_post` (" +
			"`parent_uid` INTEGER NOT NULL," +
			"`child_uid` INTEGER NOT NULL UNIQUE," +
			"PRIMARY KEY(`parent_uid`,`child_uid`)" +
		");",
		]

	var uid: Int
	var content: String
	var senderId: Int
	var updatedAt: Int
	var parentUid: Int?

	var children: [Post]?

	var isFault: Bool { return children == nil }

}

extension Post {

	func replace(into database: SQLite) throws {
		try database.execute(
			statement: "REPLACE INTO `posts` VALUES (:1, :2, :3, :4);",
			doBindings: { statement in
				try statement.bind(position: 1, uid)
				try statement.bind(position: 2, content)
				try statement.bind(position: 3, senderId)
				try statement.bind(position: 4, updatedAt)
		})
		guard let parentUid = self.parentUid else { return }
		try database.execute(
			statement: "INSERT INTO `post_post` VALUES (:1, :2);",
			doBindings: { statement in
				try statement.bind(position: 1, parentUid)
				try statement.bind(position: 2, uid)
		})
	}

}

extension Post {

	static func get(primaryKeyValue: String, from database: SQLite) throws -> Post? {
		var post: Post?
		try database.forEachRow(
			statement: "SELECT * FROM `posts` WHERE `uid` = :1;",
			doBindings: { statement in
				try statement.bind(position: 1, primaryKeyValue)
		},
			handleRow: { statement, _ in
//				post = Post(uid: statement.columnInt(position: 1), content: statement.columnText(position: 0), parentUid: nil)
		})
		return post
	}

	static func getAll(from database: SQLite) throws -> [Post] { return [] }

}
