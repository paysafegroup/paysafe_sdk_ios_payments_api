//
//  Paysafe3DS+Configuration.swift
//
//
//  Copyright (c) 2024 Paysafe Group
//

import CardinalMobile
#if canImport(PaysafeCommon)
import PaysafeCommon
#endif

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
        var supportedUI: SupportedUI = .both

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
            switch supportedUI {
            case .native:
                configuration.renderType = [
                    CardinalSessionRenderTypeOTP,
                    CardinalSessionRenderTypeOOB,
                    CardinalSessionRenderTypeSingleSelect,
                    CardinalSessionRenderTypeMultiSelect
                ]
            case .html, .both:
                configuration.renderType = [
                    CardinalSessionRenderTypeOTP,
                    CardinalSessionRenderTypeHTML,
                    CardinalSessionRenderTypeOOB,
                    CardinalSessionRenderTypeSingleSelect,
                    CardinalSessionRenderTypeMultiSelect
                ]
            }
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
