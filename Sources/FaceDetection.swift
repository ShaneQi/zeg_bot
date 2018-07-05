//
//  FaceDetection.swift
//  ZEGBot
//
//  Created by Shane Qi on 7/5/18.
//

import Foundation

func faceDetectionRequestBody(withImage data: Data) -> Data {
	return """
	{
		"requests": [
			{
				"image": {
					"content": "\(String(data: data.base64EncodedData(), encoding: .utf8) ?? "")"
				},
				"features": [
					{
						"type": "FACE_DETECTION"
					}
				]
			}
		]
	}
	""".data(using: .utf8) ?? Data()
}

struct FaceDetectionResponse: Decodable {

	let hasFaces: Bool

	private enum CodingKeys: String, CodingKey {
		case responses
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let dataArray = try container.decode([Anything].self, forKey: .responses)
		self.hasFaces = !dataArray.isEmpty
	}

}

struct Anything: Decodable {

	init(from decoder: Decoder) throws {
	}

}

func hasFacesInResponse(_ data: Data) -> Bool {
	do {
		let resposne = try JSONDecoder().decode(FaceDetectionResponse.self, from: data)
		return resposne.hasFaces
	} catch {
		return false
	}
}
