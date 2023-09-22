//
//  Paysafe3DS+Configuration.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import CardinalMobile

public extension Paysafe3DS {
    /// Configurations required for the 3DS flow
    struct Configuration {
        /// Environment used: staging or production
        let environment: APIEnvironment
        /// Sets the maximum amount of time (in milliseconds) for all exchanges
        let requestTimeout: UInt
        /// Challenge timeout in minutes
        let challengeTimeout: UInt
        /// Interface types that the device supports for displaying specific challenge user interfaces within the SDK.
        var supportedUI: SupportedUI = .both {
            didSet {
                switch supportedUI {
                case .native:
                    renderType = [.singleSelect, .multiSelect, .oob, .otp]
                case .html, .both:
                    renderType = [.html, .singleSelect, .multiSelect, .oob, .otp]
                }
            }
        }
        /// List of all the RenderTypes that the device supports for displaying specific challenge user interfaces within the SDK
        var renderType: Set<RenderType> = [.html, .singleSelect, .multiSelect, .oob, .otp]

        /// - Parameters:
        ///   - environment: Environment used: staging or production
        ///   - requestTimeout: Sets the maximum amount of time (in milliseconds) for all exchanges
        ///   - challengeTimeout: Challenge timeout in minutes
        public init(
            environment: APIEnvironment,
            requestTimeout: UInt = 8000,
            challengeTimeout: UInt = 5
        ) {
            self.environment = environment
            self.requestTimeout = requestTimeout
            self.challengeTimeout = challengeTimeout
        }

        /// CardinalSessionConfiguration
        var cardinalSessionConfiguration: CardinalSessionConfiguration {
            let configuration = CardinalSessionConfiguration()
            configuration.deploymentEnvironment = environment.cardinalSessionEnvironment
            configuration.requestTimeout = requestTimeout
            configuration.challengeTimeout = challengeTimeout
            configuration.uiType = supportedUI.cardinalSessionUIType
            configuration.renderType = renderType.map(\.rawValue)

            // UI customization
            let uiCustomization = UiCustomization()
            let toolbarCustomization = ToolbarCustomization()
            toolbarCustomization.backgroundColor = "#FFFFFF"
            uiCustomization.setToolbar(toolbarCustomization)
            configuration.darkUiCustomization = uiCustomization
            configuration.uiCustomization = uiCustomization

            return configuration
        }
    }

    /// Paysafe3DS API environment
    enum APIEnvironment {
        /// Paysafe3DS production environment
        case production
        /// Paysafe3DS staging environment
        case staging

        /// Base url
        var baseURL: String {
            switch self {
            case .production:
                return "https://api.paysafe.com"
            case .staging:
                return "https://api.test.paysafe.com"
            }
        }

        /// CardinalSessionEnvironment
        var cardinalSessionEnvironment: CardinalSessionEnvironment {
            switch self {
            case .production:
                return .production
            case .staging:
                return .staging
            }
        }
    }

    /// Represents different render types supported
    enum RenderType: String {
        /// RenderType for OTP
        case otp = "CardinalSessionRenderTypeOTP"
        /// RenderType for HTML
        case html = "CardinalSessionRenderTypeHTML"
        /// RenderType for OOB
        case oob = "CardinalSessionRenderTypeOOB"
        /// RenderType for Single Select
        case singleSelect = "CardinalSessionRenderTypeSingleSelect"
        /// RenderType for Multi Select
        case multiSelect = "CardinalSessionRenderTypeMultiSelect"
    }

    /// Sets the Interface type that the device supports for displaying specific challenge user interfaces within the SDK.
    enum SupportedUI {
        /// Native
        case native
        /// HTML
        case html
        /// Both
        case both

        /// CardinalSessionUIType
        var cardinalSessionUIType: CardinalSessionUIType {
            switch self {
            case .native:
                return .native
            case .html:
                return .HTML
            case .both:
                return .both
            }
        }
    }
}
