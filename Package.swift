// swift-tools-version:4.0

import PackageDescription

let package = Package(
	name: "zeg_bot",
	products: [
		.executable(name: "zeg_bot", targets: ["zeg_bot"])
	],
	dependencies: [
		.package(url: "https://github.com/shaneqi/ZEGBot.git", from: Version(4, 0, 0)),
		.package(url: "https://github.com/PerfectlySoft/PerfectLib.git", from: Version(3, 0, 0)),
		.package(url: "https://github.com/PerfectlySoft/Perfect-MySQL.git", from: Version(3, 0, 0))
	],
	targets: [
		.target(name: "zeg_bot",
		        dependencies: ["ZEGBot", "PerfectMySQL", "PerfectLib"],
		        path: "./Sources")
	]
)
