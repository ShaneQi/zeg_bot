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

	mutating func dig(into database: SQLite) throws {
		guard children == nil else { return }
		self.children = []
		try database.forEachRow(
			statement: "SELECT `child_uid` FROM `post_post` WHERE `parent_uid` = 107026 ORDER BY `child_uid` ASC;",
			doBindings: { statement in
				try statement.bind(position: 1, uid)
		}, handleRow: { statement, _ in
			let childUid = statement.columnInt(position: 0)
			if let post = try Post.find(uid: childUid, from: database) {
				children?.append(post)
			}
		})
	}

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
			statement: "REPLACE INTO `post_post` VALUES (:1, :2);",
			doBindings: { statement in
				try statement.bind(position: 1, parentUid)
				try statement.bind(position: 2, uid)
		})
	}

}

extension Post {

//	static func roots(from database: SQLite) throws -> [Post] {
//		var posts = [Post]()
//		try database.forEachRow(
//		statement: "SELECT * FROM `posts` WHERE `uid` NOT IN (SELECT `child_uid` FROM `post_post`);") {
//			statement, _ in
//			let uid = statement.columnInt(position: 0)
//			let content = statement.columnText(position: 1)
//			let senderId = statement.columnInt(position: 2)
//			let updatedAt = statement.columnInt(position: 3)
//			posts.append(Post(uid: uid, content: content, senderId: senderId, updatedAt: updatedAt, parentUid: nil, children: nil))
//		}
//		return posts
//	}

	static func find(uid: Int, from database: SQLite) throws -> Post? {
		var post: Post?
		try database.forEachRow(
			statement: "SELECT * FROM `posts` WHERE `uid` = :1;",
			doBindings: { statement in
				try statement.bind(position: 1, uid)
		}, handleRow: { statement, _ in
			let uid = statement.columnInt(position: 0)
			let content = statement.columnText(position: 1)
			let senderId = statement.columnInt(position: 2)
			let updatedAt = statement.columnInt(position: 3)
			post = Post(uid: uid, content: content, senderId: senderId, updatedAt: updatedAt, parentUid: nil, children: nil)
		})
		try post?.dig(into: database)
		return post
	}

}
