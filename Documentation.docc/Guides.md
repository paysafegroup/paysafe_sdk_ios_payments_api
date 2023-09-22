
# Integrating Paysafe SDK Using Swift Package Manager

This guide will walk you through the process of integrating Paysafe-iOS-SDK into your iOS project using Swift Package Manager (SPM). Swift Package Manager is a great way to manage dependencies in your project and ensure a smooth integration experience.

## Step 1: Open Your Xcode Project

Open your Xcode project or create a new one if you don't have one already.

## Step 2: Add Paysafe-iOS-SDK Dependency

1. In Xcode, go to "File" > "Swift Packages" > "Add Package Dependency..."
2. Enter the URL of your Paysafe-iOS-SDK repository: `https://gitlab.paysafe.cloud/paysafe/merchant/payments-api/paysafe-ph-mobile-sdk` 
3. Click "Next."
4. Choose the version or branch you want to use.
5. Click "Next."
6. Select the target where you want to add the dependency.
7. Click "Finish."

## Step 3: Import Paysafe-iOS-SDK

In your code, import the Paysafe-iOS-SDK module to start using it:

```swift
// Import sdk
import PaysafeSDK

// Initialize the configuration for the SDK
let apiKey = "test_key"
let accountId = "test_accountId"
let configuration = PSAPIConfiguration(apikey: apiKey, accountId: accountId)

// Use the SDK's features
let apiClient = PSAPIClient(configuration: configuration)
