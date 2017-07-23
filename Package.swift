import PackageDescription

let package = Package(
    name: "zeg_bot",
	dependencies: [
		.Package(url: "https://github.com/shaneqi/ZEGBot.git", majorVersion: 2),
		.Package(url: "https://github.com/PerfectlySoft/PerfectLib.git", majorVersion: 2),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-SQLite.git", majorVersion: 2)
	]
)
