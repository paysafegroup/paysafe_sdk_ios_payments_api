// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Paysafe",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "PaysafeCardPayments",
            targets: ["PaysafeCardPayments"]
        ),
        .library(
            name: "Paysafe3DS",
            targets: ["Paysafe3DS"]
        ),
        .library(
            name: "PaysafeApplePay",
            targets: ["PaysafeApplePay"]
        ),
        .library(
            name: "PaysafeVenmo",
            targets: ["PaysafeVenmo"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/braintree/braintree_ios", from: "6.18.2")
    ],
    targets: [
        .binaryTarget(
            name: "PSCardinalMobile",
            path: "./Frameworks/PSCardinalMobile.xcframework"
        ),
        .target(
            name: "PaysafeCardPayments",
            dependencies: ["Paysafe3DS", "PaysafeCommon"],
            resources: [.process("PrivacyInfo.xcprivacy")]
        ),
        .target(
            name: "PaysafeCommon",
            dependencies: []
        ),
        .target(
            name: "CommonMocks",
            dependencies: ["PaysafeCommon", "Paysafe3DS", "PaysafeCardPayments"]
        ),
        .target(
            name: "Paysafe3DS",
            dependencies: ["PSCardinalMobile", "PaysafeCommon"],
            resources: [.process("PrivacyInfo.xcprivacy")]
        ),
        .target(
            name: "PaysafeApplePay",
            dependencies: ["PaysafeCommon"],
            resources: [.process("PrivacyInfo.xcprivacy")]
        ),
        .target(
            name: "PaysafeVenmo",
            dependencies: ["PaysafeCommon",
                           .product(name: "BraintreeVenmo", package: "braintree_ios"),
                           .product(name: "BraintreeCore", package: "braintree_ios")],
            resources: [.process("PrivacyInfo.xcprivacy")]
        ),
        .testTarget(
            name: "PaysafeCardPaymentsTests",
            dependencies: ["PaysafeCardPayments", "CommonMocks"]
        ),
        .testTarget(
            name: "PaysafeVenmoTests",
            dependencies: ["PaysafeVenmo", "CommonMocks"]
        ),
        .testTarget(
            name: "PaysafeCommonTests",
            dependencies: ["PaysafeCommon", "CommonMocks"]
        ),
        .testTarget(
            name: "Paysafe3DSTests",
            dependencies: ["Paysafe3DS", "CommonMocks"]
        ),
        .testTarget(
            name: "PaysafeApplePayTests",
            dependencies: ["PaysafeApplePay", "CommonMocks"]
        )
    ]
)
