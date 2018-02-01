# PlayerKit



## PlayerKit 介绍

从事移动端开发以来，一直在做音视频类的开发，苹果的播放器基本定制型太强，需要定制在开源有kxmovie，授权的vitamin等，但层次不一，经过几年的发展，尤其是在这两年直播等投资热的趋势下，音视频技术逐渐趋于成熟，随便找几个库就能解决燃眉之急，开源的力量更进一步的推进了技术的发展，我也想写个简单的项目，写出一些心得。


PlayerKit是基于AVPlayer和IJKPlayer做的一款播放内核播放模块，做IJKPlayer支持是因为AVPlayer对于一些格式协议的支持的补充，比如flv、RTMP等。

## 特点

- PlayerKit高度抽象出播放层和渲染层
- 耦合低，使用方便
- 有很多使用案例

## Installation

#### Installation with CocoaPods

To integrate PlayerKit into your Xcode project using CocoaPods, specify it in your Podfile:

```ruby
pod 'PlayerKit', '~> 0.0.1'
```

Run `pod install`


## 使用方法


```
- (PlayerKit *)playerKit {
    if (!_playerKit) {
        _playerKit = [[PlayerKit alloc] initWithPlayerView:self.playerView];
        _playerKit.playerCoreType = PlayerCoreAVPlayer;
        _playerKit.playerStatusDelegate = self;
    }
    return _playerKit;
}

//自定义渲染界面
- (PlayerNormalView *)playerView {
    if (!_playerView) {
        CGFloat width = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        CGFloat height = width * 9 / 16.0f;
        _playerView = [[PlayerNormalView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _playerView.playerNormalViewDelegate = self;
        _playerView.playerStyle = PlayerStyleSizeClassRegularHalf;

        [_playerView updateTitle:@"标题"];
        [_playerView updateSave:YES];
        [_playerView layoutIfNeeded];
        [_playerView updatePlayerPicture:nil];
        [_playerView showCanLoop:YES];
    }
    return _playerView;
}



[self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.view);
    make.left.equalTo(self.view);
    make.right.equalTo(self.view);
    CGFloat width = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    CGFloat height = width * 9 / 16.0f;
    make.height.mas_equalTo(height);
}];
[self.playerKit playUrls:@[@"http://aliuwmp3.changba.com/userdata/video/45F6BD5E445E4C029C33DC5901307461.mp4"]];
```

## more

此项目会作为长期维护项目，接受各位指导。

## License

These PlayerKit are available under the MIT license.