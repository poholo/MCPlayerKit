Pod::Spec.new do |s|
  s.name         = "MCPlayerKit"
  s.version      = "0.0.2"
  s.summary      = "MCPlayerKit is iOS Player, PlayerCoreType: AVPlayer can use play some video, IJKPlayer type can play video, Live ..."
  s.homepage     = "https://github.com/poholo/PlayerKit"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'littleplayer' => 'mailjiancheng@163.com' }
  s.social_media_url   = "https://weibo.com/lp927"

  s.requires_arc = true

  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/poholo/PlayerKit.git", :tag => "#{s.version}" }

  s.source_files  = "PlayerKit", "PlayerKit/**/*.{h,m}"
  s.public_header_files = "PlayerKit/**/*.h"
  s.frameworks = "UIKit", "Foundation", "VideoToolbox", "QuartzCore", "OpenGLES", "MobileCoreServices", 
                 "MediaPlayer", "CoreVideo", "CoreMedia", "CoreGraphics", "AVFoundation", "AudioToolbox"
  s.dependency 'IJKMediaFramework'
  
end
