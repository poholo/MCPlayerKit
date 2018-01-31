Pod::Spec.new do |s|
  s.name         = "MCPlayerKit"
  s.version      = "0.0.1"
  s.summary      = "iOS Player, PlayerCoreType: AVPlayer can use play some video, IJKPlayer type can play video, Live ..."
  s.homepage     = "https://github.com/poholo/PlayerKit"
  s.license      = "MIT"
  s.author             = { "majiancheng" => "675936746@qq.com" }
  s.social_media_url   = "https://weibo.com/lp927"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/poholo/PlayerKit.git", :tag => "#{s.version}" }
  s.source_files  = "PlayerKit", "PlayerKit/**/*.{h,m}"
  s.public_header_files = "PlayerKit/**/*.h"
  s.frameworks = "UIKit", "Foundation", "VideoToolbox", "QuartzCore", "OpenGLES", "MobileCoreServices", 
                 "MediaPlayer", "CoreVideo", "CoreMedia", "CoreGraphics", "AVFoundation", "AudioToolbox"
  #s.libraries = "libbz2", "libz"
  s.requires_arc = true
  # s.dependency "JSONKit", "~> 1.4"

end
