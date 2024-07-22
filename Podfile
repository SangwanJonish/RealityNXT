# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ReallityNXT' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ReallityNXT
pod 'SDWebImage'
  pod 'IQKeyboardManagerSwift'
  pod 'Alamofire', '= 5.0.0-rc.2'
  pod 'MBProgressHUD'
  pod 'SwiftMessages'
  pod 'DropDown'
  pod "GTProgressBar"
  pod 'SwiftyGif'
  pod 'Siren'
  #pod 'Firebase'
  pod 'GoogleSignIn'
  pod 'FBSDKLoginKit'
  pod 'ObjectMapper', '~> 3.5.3'
  pod 'AlamofireObjectMapper', '~> 6.2.0'
  pod 'FLUtilities', :git => 'https://github.com/Nickelfox/FLUtilities.git', :branch => 'develop'
  pod 'MaterialComponents/Chips', '~> 124.2.0'
  pod 'GoogleMaps'
  pod 'GooglePlaces'

  post_install do |installer|
      installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
              end
          end
      end
  end
end
