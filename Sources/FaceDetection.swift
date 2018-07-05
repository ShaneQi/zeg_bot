//
//  FaceDetection.swift
//  ZEGBot
//
//  Created by Shane Qi on 7/5/18.
//

import Foundation

func faceDetectionRequestBody(withUrlString urlString: String) -> Data {
	return """
	{
		"requests": [
			{
				"image": {
					"source": {
						"imageUri": "\(urlString)"
					}
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

func hasFacesInResponse(_ data: Data) -> Bool {
	return false
}
