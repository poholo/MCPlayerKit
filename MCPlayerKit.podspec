Pod::Spec.new do |s|
  s.name         = "MCPlayerKit"
  s.version      = "0.0.3"
  s.summary      = "MCPlayerKit is iOS Player, PlayerCoreType: AVPlayer can use play some video, IJKPlayer type can play video, Live ..."
  s.homepage     = "https://github.com/poholo/PlayerKit"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "littleplayer" => "mailjiancheng@163.com" }
  s.social_media_url   = "https://weibo.com/lp927"

  s.requires_arc = true

  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/poholo/PlayerKit.git", :tag => "#{s.version}" }

  s.subspec "PlayerKit" do |ss|
    ss.dependency "IJKMediaFramework"
    ss.source_files = "MCPlayerKit/PlayerKit/**/*.{h,m,mm}"
                      "MCPlayerKit/PlayerKit/*.{h,m,mm}"
                      
    ss.public_header_files = "MCPlayerKit/PlayerKit/**/*.h"
                             "MCPlayerKit/PlayerKit/*.h"
    ss.xcconfig = {
         'VALID_ARCHS' => 'arm64 x86_64',

    }
    ss.pod_target_xcconfig = {
          'VALID_ARCHS' => 'arm64 x86_64'
    }
  end

  s.frameworks = "UIKit", "Foundation", "VideoToolbox", "QuartzCore", "OpenGLES", "MobileCoreServices", 
                 "MediaPlayer", "CoreVideo", "CoreMedia", "CoreGraphics", "AVFoundation", "AudioToolbox"

end
