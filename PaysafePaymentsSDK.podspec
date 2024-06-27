Pod::Spec.new do |s|
  s.name             = 'PaysafePaymentsSDK'
  s.version          = '0.0.15'
  s.summary          = 'Paysafe iOS SDK that implements the Payments APIs.'
  
  s.homepage         = 'https://github.com/paysafegroup/paysafe_sdk_ios_payments_api.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Paysafe Group' => 'paysafe@paysafe.com' }
  s.source           = { :git => 'https://github.com/paysafegroup/paysafe_sdk_ios_payments_api.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '14.0'
  s.swift_version = '5.5'
  
  s.resource_bundles = { "PaysafePaymentsSDK" => “Sources/Resources/PrivacyInfo.xcprivacy” }
  
  s.subspec 'PaysafeCommon' do |common|
    common.source_files = "Sources/PaysafeCommon/**/*.swift"
  end
  
  s.subspec "PaysafeNetworking" do |networking|
    networking.source_files = "Sources/PaysafeNetworking/**/*.swift"
    networking.dependency "PaysafePaymentsSDK/PaysafeCommon"
  end
  
  s.subspec "PaysafeApplePay" do |applepay|
    applepay.source_files = "Sources/PaysafeApplePay/**/*.swift"
    applepay.dependency "PaysafePaymentsSDK/PaysafeCommon"
    applepay.resource_bundles = { "PaysafeApplePay_PrivacyInfo" => “Sources/PaysafeApplePay/PrivacyInfo.xcprivacy” }
  end
  
  #s.subspec "PaysafePayPal" do |paypal|
  #  paypal.source_files = "Sources/PaysafePayPal/**/*.swift"
  #  paypal.dependency "PaysafePaymentsSDK/PaysafeCommon"
  #  paypal.dependency 'PayPal', '~> 1.1.0'
  #  paypal.resource_bundles = { "PaysafePayPal_PrivacyInfo" => “Sources/PaysafePayPal/PrivacyInfo.xcprivacy” }
  #end
  
  s.subspec "PaysafeVenmo" do |venmo|
    venmo.source_files = "Sources/PaysafeVenmo/**/*.swift"
    venmo.dependency "PaysafePaymentsSDK/PaysafeCommon"
    venmo.dependency pod 'Braintree'
    venmo.dependency pod 'Braintree/Venmo'
    venmo.resource_bundles = { "PaysafeVenmo_PrivacyInfo" => “Sources/PaysafeVenmo/PrivacyInfo.xcprivacy” }
  end
  
  s.subspec "Paysafe3DS" do |tds|
    tds.source_files = "Sources/Paysafe3DS/**/*.swift"
    tds.dependency "PaysafePaymentsSDK/PaysafeCommon"
    tds.dependency "PaysafePaymentsSDK/PaysafeNetworking"
    tds.vendored_frameworks = 'Frameworks/CardinalMobile.xcframework'
    tds.resource_bundles = { "Paysafe3DS_PrivacyInfo" => “Sources/Paysafe3DS/PrivacyInfo.xcprivacy” }
  end
  
  s.subspec "PaysafeCore" do |core|
    core.source_files = "Sources/PaysafeCore/**/*.swift"
    core.dependency "PaysafePaymentsSDK/PaysafeCommon"
    core.dependency "PaysafePaymentsSDK/PaysafeNetworking"
    core.dependency "PaysafePaymentsSDK/Paysafe3DS"
    core.dependency "PaysafePaymentsSDK/PaysafeApplePay"
    core.dependency "PaysafePaymentsSDK/PaysafePayPal"
    core.resource_bundles = { "PaysafeCore_PrivacyInfo" => “Sources/PaysafeCore/PrivacyInfo.xcprivacy” }
  end

end
