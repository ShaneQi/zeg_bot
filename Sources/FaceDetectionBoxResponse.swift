struct FaceDetectionBoxResponse: Decodable {

	let result: [Point]

}

struct Point: Decodable {

	let height: Int
	let width: Int
	let x: Int
	let y: Int

}


