import PackageDescription

let package = Package(
    name: "zeg_bot",
	dependencies: [
		.Package(url: "https://github.com/shaneqi/ZEGBot.git", versions: Version(1,0,0)..<Version(10,0,0)),
		.Package(url: "https://github.com/PerfectlySoft/PerfectLib.git", majorVersion: 2),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-SQLite.git", majorVersion: 2)
	]
)
