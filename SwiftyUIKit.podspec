#
# Be sure to run `pod lib lint SwiftyUIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#
# 1. new code update github
# 2. local not code : pod repo add SwiftyUIKit  https://github.com/DanielZSY/SwiftyUIKit.git
#    local uodate code: cd ~/.cocoapods/repos/SwiftyUIKit. Then execute: pod repo update SwiftyUIKit
# 3. pod repo push SwiftyUIKit SwiftyUIKit.podspec --allow-warnings --sources='https://github.com/CocoaPods/Specs.git'
# 4. pod trunk push SwiftyUIKit.podspec --allow-warnings
# 5. pod install or pod update on you project execute

Pod::Spec.new do |s|
  s.name             = 'SwiftyUIKit'
  s.version          = '0.0.2'
  s.summary          = 'SwiftyUIKit'
  s.module_name      = 'SwiftyUIKit'
  
  s.homepage         = 'https://github.com/DanielZSY/SwiftyUIKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'DanielZSY' => 'danielzsy@163.com' }
  s.source           = { :git => 'https://github.com/DanielZSY/SwiftyUIKit.git', :tag => s.version.to_s }
  
  s.platform              = :ios, '10.0'
  s.swift_versions        = "5"
  s.ios.deployment_target = '10.0'
  s.pod_target_xcconfig   = { 'SWIFT_VERSION' => '5.0' }
  
  s.frameworks    = 'UIKit'
  s.libraries     = 'z', 'sqlite3', 'c++'
  s.source_files  = 'SwiftyUIKit/**/*.{swift,h,m}'
  
  s.dependency 'PKHUD'
  s.dependency 'Toast-Swift'
  s.dependency 'SwiftyLocalKit'
  s.dependency 'SKPhotoBrowser'
  s.dependency 'ESPullToRefresh'
end
