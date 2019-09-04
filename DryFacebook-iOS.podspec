#
# Be sure to run `pod lib lint DryFacebook-iOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#
# 提交仓库:
# pod spec lint DryFacebook-iOS.podspec --allow-warnings --use-libraries
# pod trunk push DryFacebook-iOS.podspec --allow-warnings --use-libraries
#

Pod::Spec.new do |s|
  
  # Git
  s.name        = 'DryFacebook-iOS'
  s.version     = '0.0.1'
  s.summary     = 'DryFacebook-iOS'
  s.homepage    = 'https://github.com/duanruiying/DryFacebook-iOS'
  s.license     = { :type => 'MIT', :file => 'LICENSE' }
  s.author      = { 'duanruiying' => '2237840768@qq.com' }
  s.source      = { :git => 'https://github.com/duanruiying/DryFacebook-iOS.git', :tag => s.version.to_s }
  s.description = <<-DESC
  TODO: Facebbok功能简化(登录).
  DESC
  
  # User
  #s.swift_version         = '5.0'
  s.ios.deployment_target = '10.0'
  s.requires_arc          = true
  s.user_target_xcconfig  = {'OTHER_LDFLAGS' => ['-w']}
  
  # Pod
  s.static_framework      = true
  s.pod_target_xcconfig   = {'OTHER_LDFLAGS' => ['-w', '-ObjC']}
  
  # Code
  s.source_files          = 'DryFacebook-iOS/Classes/Code/**/*'
  s.public_header_files   = 'DryFacebook-iOS/Classes/Code/Public/**/*.h'
  
  # System
  #s.libraries  = 'z', 'sqlite3.0', 'c++'
  s.frameworks = 'UIKit', 'Foundation'
  
  # ThirdParty
  #s.vendored_libraries  = ''
  #s.vendored_frameworks = ''
  s.dependency 'FBSDKLoginKit'
  
end
