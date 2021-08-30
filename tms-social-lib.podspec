#
# Be sure to run `pod lib lint tms-social-lib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.platform         = :ios, '13.0'
  s.ios.deployment_target = '13.0'
  s.name             = 'tms-social-lib'
  s.version          = '1.0.1'
  s.summary          = 'This is a library of Tomosia Compạny for social login'
  s.homepage         = 'https://github.com/TOMOSIA-VIETNAM/tms-lib-social-ios'
  s.requires_arc     = true
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tomosia Viet Nam Co.Ltd' => 'phuong.vo@tomosia.com' }
  s.source           = { :git => 'https://github.com/TOMOSIA-VIETNAM/tms-lib-social-ios', :tag => s.version.to_s }
  s.source_files     = 'tms-social-lib/Classes/**/*.swift'
  s.frameworks       = 'UIKit', 'AuthenticationServices'
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

  s.dependency 'FacebookCore', '0.9.0'
  s.dependency 'FacebookLogin', '0.9.0'
  s.dependency 'TwitterKit5', '5.2.0'
  s.dependency 'LineSDKSwift', '5.7.0'
  s.dependency 'GoogleSignIn', '6.0.1'

end
