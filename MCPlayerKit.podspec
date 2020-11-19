Pod::Spec.new do |s|
  s.name         = "MCPlayerKit"
  s.version      = "0.2.1"
  s.summary      = "MCPlayerKit is iOS Player, PlayerCoreType: AVPlayer can use play some video, IJKPlayer type can play video, Live ..."
  s.homepage     = "https://github.com/poholo/MCPlayerKit"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "littleplayer" => "mailjiancheng@163.com" }
  s.social_media_url   = "https://weibo.com/lp927"

  s.requires_arc = true

  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/poholo/MCPlayerKit.git", :tag => "#{s.version}" }

  s.default_subspec = 'Core'

  s.subspec 'Core' do |core|
    core.source_files = 'SDK/PlayerKit/*.{h,m,mm}',
                        'SDK/PlayerKit/**/*.{h,m,mm}'
    core.public_header_files = 'SDK/PlayerKit/*.h'
    core.dependency 'MCIJKPlayer', '0.0.9'
    core.dependency 'GCDMulticastDelegate', '1.0.0'
  end
  
  s.subspec 'GeneralPlayerUI' do |general|
    general.source_files = 'SDK/GeneralPlayerUI/**/*.{h,m,mm}',
                           'SDK/GeneralPlayerUI/*.{h,m,mm}',
                           'SDK/Commen/*.{h,m,mm}'
    general.public_header_files = 'SDK/GeneralPlayerUI/*.h'
    general.dependency 'MCPlayerKit/Core'
    general.dependency 'MCVersion', '4.3.3'
    general.dependency 'MCStyle', '0.0.8'
    general.dependency 'MCBase', '0.0.2'
    general.dependency 'SDWebImage'
  end
  
  s.frameworks = "UIKit", "Foundation", "VideoToolbox", "QuartzCore", "OpenGLES", "MobileCoreServices", 
                 "MediaPlayer", "CoreVideo", "CoreMedia", "CoreGraphics", "AVFoundation", "AudioToolbox"

end
