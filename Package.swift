import PackageDescription

let package = Package(
    name: "CodeGen",
    dependencies: [
       // .Package(url: "https://github.com/Alamofire/Alamofire", majorVersion: 4, minor: 0),
        .Package(url: "https://github.com/SwiftyJSON/SwiftyJSON", majorVersion: 3, minor: 1),
    ]
)
