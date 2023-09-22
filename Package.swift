// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "Paysafe",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "PaysafeCore",
            targets: ["PaysafeCore"]
        ),
        .library(
            name: "Paysafe3DS",
            targets: ["Paysafe3DS"]
        ),
        .library(
            name: "PaysafeNetworking",
            targets: ["PaysafeNetworking"]
        ),
        .library(
            name: "PaysafeCommon",
            targets: ["PaysafeCommon"]
        ),
        .library(
            name: "PaysafeApplePay",
            targets: ["PaysafeApplePay"]
        ),
        .library(
            name: "PaysafePayPal",
            targets: ["PaysafePayPal"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/paypal/paypal-ios", from: "1.1.0")
    ],
    targets: [
        .binaryTarget(
            name: "CardinalMobile",
            path: "./Frameworks/CardinalMobile.xcframework"
        ),
        .target(
            name: "PaysafeCore",
            dependencies: ["Paysafe3DS", "PaysafeApplePay", "PaysafePayPal", "PaysafeNetworking", "PaysafeCommon"]
        ),
        .target(
            name: "PaysafeCommon",
            dependencies: []
        ),
        .target(
            name: "Paysafe3DS",
            dependencies: ["CardinalMobile", "PaysafeNetworking", "PaysafeCommon"]
        ),
        .target(
            name: "PaysafeNetworking",
            dependencies: ["PaysafeCommon"]
        ),
        .target(
            name: "PaysafeApplePay",
            dependencies: ["PaysafeCommon"]
        ),
        .target(
            name: "PaysafePayPal",
            dependencies: ["PaysafeCommon", .product(name: "PayPalNativePayments", package: "paypal-ios")]
        ),
        .testTarget(
            name: "PaysafeCoreTests",
            dependencies: ["PaysafeCore"]
        ),
        .testTarget(
            name: "PaysafeCommonTests",
            dependencies: ["PaysafeCommon"]
        ),
        .testTarget(
            name: "Paysafe3DSTests",
            dependencies: ["Paysafe3DS"]
        ),
        .testTarget(
            name: "PaysafeNetworkingTests",
            dependencies: ["PaysafeNetworking"]
        ),
        .testTarget(
            name: "PaysafeApplePayTests",
            dependencies: ["PaysafeApplePay"]
        ),
        .testTarget(
            name: "PaysafePayPalTests",
            dependencies: ["PaysafePayPal"]
        )
    ]
)
