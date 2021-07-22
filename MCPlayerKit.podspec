Pod::Spec.new do |s|
  s.name         = "MCPlayerKit"
  s.version      = "0.2.3"
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
    core.dependency 'MCIJKPlayer'
    core.dependency 'GCDMulticastDelegate'
  end

  s.subspec 'SwiftCore' do |core|
    core.source_files = 'SDK/PlayerKit/*.{h,m,mm}',
                        'SDK/PlayerKit/**/*.{h,m,mm}'
    core.public_header_files = 'SDK/PlayerKit/*.h'
    core.dependency 'GCDMulticastDelegate'
  end
  
  s.subspec 'GeneralPlayerUI' do |general|
    general.source_files = 'SDK/GeneralPlayerUI/**/*.{h,m,mm}',
                           'SDK/GeneralPlayerUI/*.{h,m,mm}',
                           'SDK/Commen/*.{h,m,mm}'
    general.public_header_files = 'SDK/GeneralPlayerUI/*.h'
    general.dependency 'MCPlayerKit/Core'
    general.dependency 'MCVersion'
    general.dependency 'MCStyle'
    general.dependency 'MCBase'
    general.dependency 'SDWebImage'
  end

  s.subspec 'SwiftGeneralPlayerUI' do |general|
    general.source_files = 'SDK/GeneralPlayerUI/**/*.{h,m,mm}',
                           'SDK/GeneralPlayerUI/*.{h,m,mm}',
                           'SDK/Commen/*.{h,m,mm}'
    general.public_header_files = 'SDK/GeneralPlayerUI/*.h'
    general.dependency 'MCPlayerKit/SwiftCore'
    general.dependency 'MCVersion'
    general.dependency 'MCStyle'
    general.dependency 'MCBase'
    general.dependency 'SDWebImage'
  end
  
  s.frameworks = "UIKit", "Foundation", "VideoToolbox", "QuartzCore", "OpenGLES", "MobileCoreServices", 
                 "MediaPlayer", "CoreVideo", "CoreMedia", "CoreGraphics", "AVFoundation", "AudioToolbox", 'IJKP'

end
