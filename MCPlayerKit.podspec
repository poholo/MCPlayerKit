Pod::Spec.new do |s|
  s.name         = "MCPlayerKit"
  s.version      = "0.1.7"
  s.summary      = "MCPlayerKit is iOS Player, PlayerCoreType: AVPlayer can use play some video, IJKPlayer type can play video, Live ..."
  s.homepage     = "https://github.com/poholo/PlayerKit"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "littleplayer" => "mailjiancheng@163.com" }
  s.social_media_url   = "https://weibo.com/lp927"

  s.requires_arc = true

  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/poholo/PlayerKit.git", :tag => "#{s.version}" }

  s.default_subspec = 'Core'

  s.subspec 'Core' do |core|
    core.source_files = 'SDK/PlayerKit/*.{h,m,mm}',
                        'SDK/PlayerKit/**/*.{h,m,mm}'
    core.public_header_files = 'SDK/PlayerKit/*.h'
    core.dependency 'MCIJKPlayer', '0.0.5'
    core.dependency 'GCDMulticastDelegate'
  end

  s.subspec 'GeneralPlayerUI' do |general|
    general.source_files = 'SDK/GeneralPlayerUI/**/*.{h,m,mm}',
                           'SDK/GeneralPlayerUI/*.{h,m,mm}',
                           'SDK/Commen/*.{h,m,mm}'
    general.public_header_files = 'SDK/GeneralPlayerUI/*.h'
    general.dependency 'MCPlayerKit/Core'
    general.dependency 'SDVersion'
    general.dependency 'MCStyle'
    general.dependency 'SDWebImage'
  end

  s.xcconfig = {
       'VALID_ARCHS' => 'arm64 x86_64',
       'USER_HEADER_SEARCH_PATHS' => '${PROJECT_DIR}/Pods/**'
  }
  s.pod_target_xcconfig = {
        'VALID_ARCHS' => 'arm64 x86_64'
  }

  s.frameworks = "UIKit", "Foundation", "VideoToolbox", "QuartzCore", "OpenGLES", "MobileCoreServices", 
                 "MediaPlayer", "CoreVideo", "CoreMedia", "CoreGraphics", "AVFoundation", "AudioToolbox"

end
