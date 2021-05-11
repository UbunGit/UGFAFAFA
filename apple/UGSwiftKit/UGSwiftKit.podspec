# Run `pod lib lint SwiftUIKit.podspec' to ensure this is a valid spec.

Pod::Spec.new do |s|
  s.name             = 'UGSwiftKit'
  s.version          = '1.0.1'
  s.swift_versions   = ['5.3']
  s.summary          = '...'

  s.description      = <<-DESC
  description.
                       DESC

  s.homepage         = 'https://github.com/pvieito/PythonKit.git'
  s.license          = { :type => 'MIT' }
  s.author           = { '静静的白色外套' => '296019487@qq.com' }
  s.source           = { :git => '', :tag => s.version.to_s }
  s.social_media_url = ''

  s.swift_version = '5.3'
  s.ios.deployment_target = '13.0'
  s.tvos.deployment_target = '13.0'
  s.macos.deployment_target = '11.0'
  s.watchos.deployment_target = '6.0'
  
  s.default_subspec = 'Base'
   
   s.subspec 'Base' do |spec|
     spec.source_files = 'Sources/UGSwiftKit/Sources/**/*.swift'
     spec.resource_bundles = {
       'UGKitBundle' =>   ['Sources/UGSwiftKit/resources/**/*.xcassets']
     }
   end
 
  s.subspec 'Appicon' do |spec|
    spec.ios.dependency 'UGSwiftKit/Base'
    spec.source_files = 'Sources/Appicon/Sources/**/*.swift'
    spec.resource = ['Sources/Appicon/resources/**/*.xcassets']
#    spec.resource_bundles = {
#      'AppiconBundle' =>   ['Sources/Appicon/resources/**/*.xcassets']
#    }
  end
  
  s.subspec 'UGAnalyse' do |spec|
    spec.ios.dependency 'UGSwiftKit/Base'
    spec.dependency 'PythonKit'
    spec.source_files = 'Sources/UGAnalyse/Sources/**/*.swift'
    spec.resource = ['Sources/Appicon/resources/**/*.xcassets']

  end
  
  

  
end
