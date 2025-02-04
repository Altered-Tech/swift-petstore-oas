// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-sam-petstore",
    platforms: [.macOS(.v14)],
    products: [
        .executable(name: "GetPetById", targets: ["GetPetById"]),
        .executable(name: "GetPetsByStatus", targets: ["GetPetsByStatus"]),
        .executable(name: "GetPetsByTags", targets: ["GetPetsByTags"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime.git", from: "1.0.0-alpha.1"),
        .package(url: "https://github.com/swift-server/swift-aws-lambda-events.git", from: "0.1.0"),
        .package(url: "https://github.com/apple/swift-openapi-generator", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.0.0"),
        .package(url: "https://github.com/sebsto/swift-openapi-lambda", from: "0.1.1")
    ],
    targets: [
        .executableTarget(
          name: "GetPetById",
          dependencies: [
            .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
            .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-events"),
            .product(name: "OpenAPIRuntime",package: "swift-openapi-runtime"),
            .product(name: "OpenAPILambda",package: "swift-openapi-lambda"),
          ],
          path: "Sources/Pet/GetPetById",
          resources: [
            .copy("../../openapi.yaml"),
            .copy("openapi-generator-config.yaml")
          ],
          plugins: [
            .plugin(
                name: "OpenAPIGenerator",
                package: "swift-openapi-generator"
            )
          ]
        ),
        .executableTarget(
          name: "GetPetsByStatus",
          dependencies: [
            .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
            .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-events"),
            .product(name: "OpenAPIRuntime",package: "swift-openapi-runtime"),
            .product(name: "OpenAPILambda",package: "swift-openapi-lambda"),
          ],
          path: "Sources/Pet/GetPetsByStatus",
          resources: [
            .copy("../../openapi.yaml"),
            .copy("openapi-generator-config.yaml")
          ],
          plugins: [
            .plugin(
                name: "OpenAPIGenerator",
                package: "swift-openapi-generator"
            )
          ]
        ),
        .executableTarget(
          name: "GetPetsByTags",
          dependencies: [
            .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
            .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-events"),
            .product(name: "OpenAPIRuntime",package: "swift-openapi-runtime"),
            .product(name: "OpenAPILambda",package: "swift-openapi-lambda"),
          ],
          path: "Sources/Pet/GetPetsByTags",
          resources: [
            .copy("../../openapi.yaml"),
            .copy("openapi-generator-config.yaml")
          ],
          plugins: [
            .plugin(
                name: "OpenAPIGenerator",
                package: "swift-openapi-generator"
            )
          ]
        ),
        .executableTarget(
          name: "UpdatePet",
          dependencies: [
            .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
            .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-events"),
            .product(name: "OpenAPIRuntime",package: "swift-openapi-runtime"),
            .product(name: "OpenAPILambda",package: "swift-openapi-lambda"),
          ],
          path: "Sources/Pet/UpdatePet",
          resources: [
            .copy("../../openapi.yaml"),
            .copy("openapi-generator-config.yaml")
          ],
          plugins: [
            .plugin(
                name: "OpenAPIGenerator",
                package: "swift-openapi-generator"
            )
          ]
        ),
        .executableTarget(
          name: "AddPet",
          dependencies: [
            .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
            .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-events"),
            .product(name: "OpenAPIRuntime",package: "swift-openapi-runtime"),
            .product(name: "OpenAPILambda",package: "swift-openapi-lambda"),
          ],
          path: "Sources/Pet/AddPet",
          resources: [
            .copy("../../openapi.yaml"),
            .copy("openapi-generator-config.yaml")
          ],
          plugins: [
            .plugin(
                name: "OpenAPIGenerator",
                package: "swift-openapi-generator"
            )
          ]
        ),
    ]
)

