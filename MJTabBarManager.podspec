#
# Be sure to run `pod lib lint MJTabBarManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MJTabBarManager"
  s.version          = "0.1.0"
  s.summary          = "This is a custom TabbarController with the function of ads."

  s.homepage         = "https://github.com/Musjoy/MJTabBarManager"
  s.license          = 'MIT'
  s.author           = { "Raymond" => "Ray.musjoy@gmail.com" }
  s.source           = { :git => "https://github.com/Musjoy/MJTabBarManager.git", :tag => "v-#{s.version}" }

  s.ios.deployment_target = '7.0'

  s.source_files = 'MJTabBarManager/Classes/**/*'

  s.user_target_xcconfig = {
    'GCC_PREPROCESSOR_DEFINITIONS' => 'MODULE_TABBAR_MANAGER'
  }
  
  s.dependency 'ModuleCapability', '~> 0.1.1'
  s.prefix_header_contents = '#import "ModuleCapability.h"'

end
