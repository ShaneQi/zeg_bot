// swift-tools-version:4.1

import PackageDescription

let package = Package(         
        name: "zeg_bot",       
        products: [            
                // Products define the executables and libraries produced by a package, and make them visible to other packages. 
                .executable(
                        name: "zeg_bot",        
                        targets: ["zeg_bot"]),          
                ],
        dependencies: [
                .package(url: "https://github.com/shaneqi/ZEGBot", .exactItem(Version(4, 0, 1))),
        ],
        targets: [
                // Targets are the basic building blocks of a package. A target can define a module or a test suite.
                // Targets can depend on other targets in this package, and on products in packages which this package depends on.
                .target(
                        name: "zeg_bot",
                        dependencies: ["ZEGBot"],
                        path: "Sources")
                ]
)
