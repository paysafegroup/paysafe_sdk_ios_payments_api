Pod::Spec.new do |s|
  s.name             = 'PaysafePaymentsSDK'
  s.version          = '1.0.0'
  s.summary          = 'Paysafe iOS SDK that implements the Payments APIs.'
  
  s.homepage         = 'https://github.com/paysafegroup/paysafe_sdk_ios_payments_api.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Paysafe Group' => 'paysafe@paysafe.com' }
  s.source           = { :git => 'https://github.com/paysafegroup/paysafe_sdk_ios_payments_api.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '14.0'
  s.swift_version = '5.9'

  s.resource_bundles = { "PaysafePaymentsSDK" => "Sources/Resources/PrivacyInfo.xcprivacy" }
  
  s.subspec 'PaysafeCommon' do |common|
    common.source_files = "Sources/PaysafeCommon/**/*.swift"
  end
  
  s.subspec "PaysafeApplePay" do |applepay|
    applepay.source_files = "Sources/PaysafeApplePay/**/*.swift"
    applepay.dependency "PaysafePaymentsSDK/PaysafeCommon"
    applepay.resource_bundles = { "PaysafeApplePay_PrivacyInfo" => "Sources/PaysafeApplePay/PrivacyInfo.xcprivacy" }
  end
  
  s.subspec "PaysafeVenmo" do |venmo|
    venmo.source_files = "Sources/PaysafeVenmo/**/*.swift"
    venmo.dependency "PaysafePaymentsSDK/PaysafeCommon"
    venmo.dependency 'Braintree/Venmo', '>= 6.18.2', '< 7.0.0'
    venmo.resource_bundles = { "PaysafeVenmo_PrivacyInfo" => "Sources/PaysafeVenmo/PrivacyInfo.xcprivacy" }
  end
  
  s.subspec "Paysafe3DS" do |tds|
    tds.source_files = "Sources/Paysafe3DS/**/*.swift"
    tds.dependency "PaysafePaymentsSDK/PaysafeCommon"
    tds.vendored_frameworks = 'Frameworks/CardinalMobile.xcframework'
    tds.resource_bundles = { "Paysafe3DS_PrivacyInfo" => "Sources/Paysafe3DS/PrivacyInfo.xcprivacy" }
  end
  
  s.subspec "PaysafeCardPayments" do |cardPayments|
    cardPayments.source_files = "Sources/PaysafeCardPayments/**/*.swift"
    cardPayments.dependency "PaysafePaymentsSDK/PaysafeCommon"
    cardPayments.dependency "PaysafePaymentsSDK/Paysafe3DS"
    cardPayments.resource_bundles = { "PaysafeCardPayments_PrivacyInfo" => "Sources/PaysafeCardPayments/PrivacyInfo.xcprivacy" }
  end

end
