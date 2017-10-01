//
//  ZEGBotPlugin.swift
//  zeg_bot
//
//  Created by Shane Qi on 6/4/16.
//
//

#if os(Linux)
	import SwiftGlibc
#else
	import Darwin
#endif
import ZEGBot
import Foundation
import Kanna

class ZEGBotPlugin {
	
	var bot: ZEGBot
	
	init(bot: ZEGBot) { self.bot = bot }
	
	func smartReply(to receiver: Message, content: Any, type: contentType) {
		
		var sendTo: Sendable = receiver.chat
		if let replyTo = receiver.replyToMessage { sendTo = replyTo }
		switch type {
		case .Text:
			bot.send(message: (content as! String), to: sendTo)
		case .PhotoSize:
			bot.send(photo: (content as! PhotoSize), to: sendTo)
		case .Sticker:
			bot.send(sticker: (content as! Sticker), to: sendTo)
		}
		
	}
	
	func distance(between A: Location, and B: Location) -> Double{
		
		func degreeToRadius(_ degree: Double) -> Double{
			
			let radius: Double = degree * 3.1415926 / 180
			return radius
			
		}
		
		let latA = A.latitude
		let lonA = A.longitude
		let latB = B.latitude
		let lonB = B.longitude
		let R: Double = 3956
		
		let degreeLat = degreeToRadius((latA - latB))
		let degreeLon = degreeToRadius((lonA - lonB))
		
		let a = sin(degreeLat/2) * sin(degreeLat/2) +
			cos(degreeToRadius(latA)) * cos(degreeToRadius(latB)) *
			sin(degreeLon/2) * sin(degreeLon/2)
		
		let c = atan2(sqrt(a), sqrt(1 - a)) * 2
		return R * c
		
	}

	private var brJobs: [String: [Job]] = [:]

	func syncBRJobs(filterNew: Bool) {
		var jobs = [String: [Job]]()
		let urlRequest = URLRequest(url: URL(string: "https://careers.jobscore.com/careers/bottlerocket")!)
		let session = URLSession(configuration: URLSessionConfiguration.default)
		session.dataTask(with: urlRequest) { data, _, _ in
			if let data = data,
				let content = String(data: data, encoding: String.Encoding.utf8),
				let doc = HTML(html: content, encoding: .utf8),
				let jobList = doc.xpath("//div[@class='js-area-container js-section-job-list']").first {
				let departmentElements = jobList.xpath(".//div[@class='js-job-departament-container']")
				for departmentElement in departmentElements {
					let departmentName = (departmentElement.xpath(".//div[@class='js-job-department']")
						.first?.text ?? "UNKNOWN DEPARTMENT").trimmingCharacters(in: ["\n"])
					var jobList = [Job]()
					for jobElement in departmentElement.xpath(".//div[@class='js-job-container']") {
						jobList.append(Job(
							title: jobElement.xpath(".//span[@class='js-job-title']").first?.text,
							location: jobElement.xpath(".//span[@class='js-job-location']").first?.text))
					}
					if jobList.count > 0 {
						jobs[departmentName] = jobList
					}
				}
			}
			var messages: [String] = []
			for (department, departmentJobs) in jobs {
				var newJobs = departmentJobs
				if filterNew, let oldJobs = self.brJobs[department] {
						newJobs = newJobs
							.filter { newJob in
								!oldJobs.contains { oldJob in
									oldJob.title == newJob.title
								}
							}
				}
				if newJobs.count > 0 {
					messages.append(department + "\n" + newJobs
						.map { return String(describing: $0) }
						.joined(separator: "\n"))
				}
			}
			self.brJobs = jobs
			if messages.count == 0 { messages.append(filterNew ? "No New Jobs" : "No Jobs Found") }
			messages.append("https://careers.jobscore.com/careers/bottlerocket")
			self.bot.send(message: messages.joined(separator: "\n\n"),
			              to: shaneChat,
			              parseMode: .markdown,
			              disableWebPagePreview: true)
			}.resume()
	}

	func refreshBlog() {
		var urlRequest = URLRequest(url: URL(string: "https://server.shaneqi.com/hooks/rusty_blog")!)
		urlRequest.httpMethod = "POST"
		let session = URLSession(configuration: URLSessionConfiguration.default)
		session.dataTask(with: urlRequest) { _, _, _ in }.resume()
	}
	
}

enum contentType {
	
	case Text
	case PhotoSize
	case Sticker
	
}

extension PhotoSize {

	init(file_id: String, width: Int, height: Int) {
		self.fileId = file_id
		self.width = width
		self.height = height
		self.fileSize = nil
	}

}

extension Sticker {

	init(file_id: String, width: Int, height: Int) {
		self.fileId = file_id
		self.width = width
		self.height = height
		self.fileSize = nil
		self.thumb = nil
		self.emoji = nil
	}
	
}
