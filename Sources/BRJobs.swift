//
//  BRJobs.swift
//  zeg_bot
//
//  Created by Shane Qi on 7/23/17.
//
//

import Kanna
import Dispatch
import Foundation

struct Job: CustomStringConvertible {
	let title: String?
	let location: String?

	init(title: String?, location: String?) {
		self.title = title?.trimmingCharacters(in: ["\n"])
		self.location = location?.trimmingCharacters(in: ["\n"])
	}

	public var description: String {
		return "\(title ?? "UNKNOWN_TITLE") - \(location ?? "UNKNOWN_LOCATION")"
	}

}

struct Department: CustomStringConvertible {
	let name: String?
	var jobs: [Job]

	init(name: String?) {
		self.name = name?.trimmingCharacters(in: ["\n"])
		jobs = []
	}

	public var description: String {
		return "\(name ?? "UNKNOWN_DEPARTMENT")\n" + jobs.map({ "\($0)" }).joined(separator: "\n") + "\n"
	}

}
