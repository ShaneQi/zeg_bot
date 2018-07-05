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

	let responses: [FaceAnnotations]

	private enum CodingKeys: String, CodingKey {
		case responses
	}

}

struct FaceAnnotations: Decodable {

	let hasAnything: Bool

	private enum CodingKeys: String, CodingKey {
		case faceAnnotations
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.hasAnything = container.contains(.faceAnnotations)
	}

}

func hasFacesInResponse(_ data: Data) -> Bool {
	do {
		let resposne = try JSONDecoder().decode(FaceDetectionResponse.self, from: data)
		return resposne.responses.first?.hasAnything ?? false
	} catch {
		return false
	}
}
