//
//  VideoPlayerView.m
//  Valhalla
//
//  Created by mademao on 2018/9/30.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "VideoPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface VideoPlayerView ()

//初始化时的屏幕亮度
@property (nonatomic, assign) CGFloat startBrightness;
//播放器
@property (nonatomic, strong) AVPlayer *player;
//当前播放项目
@property (nonatomic, strong) AVPlayerItem *currentPlayerItem;
//音量调节杆
@property (nonatomic, strong) UISlider *volumSilider;
//播放/暂停按钮
@property (nonatomic, strong) UIButton *playOrPauseButton;
//进度条
@property (nonatomic, strong) UISlider *rateSlider;
//当前时间
@property (nonatomic, assign) NSTimeInterval currentTime;
//当前时间label
@property (nonatomic, strong) UILabel *currentTimeLabel;
//总时间
@property (nonatomic, assign) NSTimeInterval totalTime;
//总时间label
@property (nonatomic, strong) UILabel *totalTimeLable;
//播放状态
@property (nonatomic, assign) BOOL isPlaying;
//循环器
@property (nonatomic, strong) CADisplayLink *link;
//是否在滑动
@property (nonatomic, assign) BOOL isPan;
//开始滑动位置
@property (nonatomic, assign) CGPoint startPoint;
//上次滑动位置
@property (nonatomic, assign) CGPoint lastPoint;

@end

@implementation VideoPlayerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initAll];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initAll];
    }
    return self;
}

//初始化设置
- (void)initAll
{
    self.backgroundColor = [UIColor whiteColor];
    self.startBrightness = [UIScreen mainScreen].brightness;
    //设置扬声器可以播放
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    
    //初始化播放器
    self.player = [[AVPlayer alloc] init];
    
    //添加视频显示Layer
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = self.bounds;
    //    playerLayer.videoGravity = AVLayerVideoGravityResize;
    [self.layer addSublayer:playerLayer];
    
    //添加音量控件
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    [volumeView sizeToFit];
    self.volumSilider = nil;
    for (UIView *view in volumeView.subviews) {
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]) {
            self.volumSilider = (UISlider *)view;
            break;
        }
    }
    
    //播放暂停按钮
    self.playOrPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playOrPauseButton.frame = CGRectMake(10, self.frame.size.height - 10 - 40, 40, 40);
    [self.playOrPauseButton addTarget:self action:@selector(playOrPauseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.playOrPauseButton];
    
    //进度条
    self.rateSlider = [[UISlider alloc] initWithFrame:CGRectMake(60, self.frame.size.height - 10 - 40, self.frame.size.width - 120, 30)];
    self.rateSlider.minimumValue = 0.0;
    self.rateSlider.maximumValue = 1.0;
    self.rateSlider.minimumTrackTintColor = [UIColor grayColor];
    self.rateSlider.maximumTrackTintColor = [UIColor blackColor];
    [self.rateSlider addTarget:self action:@selector(rateSliderAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.rateSlider];
    //当前时间
    self.currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, self.frame.size.height - 10 - 10, self.rateSlider.frame.size.width / 2., 10)];
    self.currentTimeLabel.textAlignment = NSTextAlignmentLeft;
    self.currentTimeLabel.font = [UIFont systemFontOfSize:19];
    self.currentTimeLabel.numberOfLines = 0;
    self.currentTimeLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.currentTimeLabel];
    //总时间
    self.totalTimeLable = [[UILabel alloc] initWithFrame:CGRectMake(60 + self.currentTimeLabel.frame.size.width, self.frame.size.height - 10 - 10, self.currentTimeLabel.frame.size.width, 10)];
    self.totalTimeLable.textAlignment = NSTextAlignmentRight;
    self.totalTimeLable.font = [UIFont systemFontOfSize:19];
    self.totalTimeLable.numberOfLines = 0;
    self.totalTimeLable.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.totalTimeLable];
    
    //循环器
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(linkAction)];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

//加载本地视频
- (void)loadLocalVedioWithURL:(NSString *)urlStr
{
    AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:urlStr]];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithAsset:asset];
    [self loadVedioWithPlayerItem:playerItem];
}

//加载网络视频
- (void)loadNetVedioWithURL:(NSString *)urlStr
{
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:[urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    [self loadVedioWithPlayerItem:playerItem];
}

//加载视频
- (void)loadVedioWithPlayerItem:(AVPlayerItem *)playerItem
{
    [self.currentPlayerItem removeObserver:self forKeyPath:@"status" context:nil];
    self.currentPlayerItem = playerItem;
    [self.currentPlayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self pause];
    [self.player replaceCurrentItemWithPlayerItem:self.currentPlayerItem];
    //保证在加载完视频之前按钮不可用
    self.playOrPauseButton.userInteractionEnabled = NO;
}

//播放
- (void)play
{
    [self.player play];
    self.isPlaying = YES;
}

//暂停
- (void)pause
{
    [self.player pause];
    self.isPlaying = NO;
}

//播放暂停按钮事件
- (void)playOrPauseButtonAction:(UIButton *)button
{
    if (self.isPlaying) {
        [self pause];
    } else {
        [self play];
    }
}

//进度条事件
- (void)rateSliderAction
{
    CGFloat rate = self.rateSlider.value;
    [self.player seekToTime:CMTimeMakeWithSeconds(rate * self.totalTime, 1)];
}

//触摸事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.isPan = YES;
    self.startPoint = [[touches anyObject] locationInView:self];
    self.lastPoint = self.startPoint;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endPan];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.isPan) {
        CGPoint point = [[touches anyObject] locationInView:self];
        CGFloat xSpace = sqrt((point.x - self.startPoint.x) * (point.x - self.startPoint.x));
        CGFloat ySpace = point.y - self.lastPoint.y;
        if (xSpace > 30) {
            [self endPan];
        } else {
            if (self.startPoint.x > self.frame.size.width / 2.) {
                //音量
                float volum = self.volumSilider.value;
                [self.volumSilider setValue:volum - (ySpace / 30. / 3) animated:YES];
                //解决部分机型上音量调大到某一程度无法继续调大的问题
                if (ySpace < 0) {
                    if (volum - (ySpace / 30. / 3) - self.volumSilider.value >= 0.1) {
                        [self.volumSilider setValue:0.1 animated:NO];
                        [self.volumSilider setValue:volum - (ySpace / 30. / 3) animated:YES];
                    }
                }
            } else {
                //亮度
                [[UIScreen mainScreen] setBrightness:[UIScreen mainScreen].brightness - (ySpace / 30. / 3)];
            }
            self.lastPoint = point;
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endPan];
}

- (void)endPan
{
    self.isPan = NO;
    self.startPoint = CGPointZero;
}

- (void)setIsPlaying:(BOOL)isPlaying
{
    _isPlaying = isPlaying;
    
    //改变播放暂停按钮状态
    if (isPlaying) {
        self.playOrPauseButton.backgroundColor = [UIColor redColor];
    } else {
        self.playOrPauseButton.backgroundColor = [UIColor greenColor];
    }
}

- (void)linkAction
{
    if (self.isPlaying) {
        self.currentTime = CMTimeGetSeconds(self.player.currentTime);
        self.rateSlider.value = self.currentTime / self.totalTime;
        NSLog(@"%@ - %@ = %@", @(self.totalTime), @(self.currentTime), @(self.totalTime - self.currentTime));
        if (self.totalTime - self.currentTime <= 0) {
            //播放结束
            [[UIScreen mainScreen] setBrightness:self.startBrightness];
            [self pause];
        }
    }
}

//监听回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([object isKindOfClass:[AVPlayerItem class]]) {
        AVPlayerItem *playerItem = (AVPlayerItem *)object;
        if ([keyPath isEqualToString:@"status"]) {
            if (playerItem.status == AVPlayerItemStatusReadyToPlay){
                NSLog(@"准备播放");
                //接触按钮不可用
                self.playOrPauseButton.userInteractionEnabled = YES;
                //自动播放
                [self play];
                //获取视频的总播放时长
                self.totalTime = CMTimeGetSeconds(self.player.currentItem.duration);
                self.currentTime = CMTimeGetSeconds(self.player.currentTime);
            } else{
                NSLog(@"播放失败");
            }
        }
    }
}

- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    _currentTime = currentTime;
    self.currentTimeLabel.text = [self calculateTime:currentTime];
}

- (void)setTotalTime:(NSTimeInterval)totalTime
{
    _totalTime = totalTime;
    self.totalTimeLable.text = [self calculateTime:totalTime];
}

- (NSString *)calculateTime:(NSTimeInterval)time
{
    NSTimeInterval sec = (NSInteger)time % 60;
    NSTimeInterval min = (NSInteger)time / 60;
    
    NSString *string = [NSString stringWithFormat:@"%02ld:%02ld", (long)min, (long)sec];
    return string;
}

- (void)dealloc
{
    [self.currentPlayerItem removeObserver:self forKeyPath:@"status" context:nil];
    [[UIScreen mainScreen] setBrightness:self.startBrightness];
}

@end
