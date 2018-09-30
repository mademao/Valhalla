//
//  VideoPlayerViewController.m
//  Valhalla
//
//  Created by mademao on 2018/9/30.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "VideoPlayerView.h"

@interface VideoPlayerViewController ()

@property (nonatomic, strong) VideoPlayerView *playerView;

@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.playerView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.playerView loadNetVedioWithURL:@"http://gslb.miaopai.com/stream/O7vRTkXI4gvjBBTF3b1NwSzMdKfntLOtNDCgHQ__.mp4"];
}

- (void)dealloc
{
    if (_playerView) {
        [_playerView pause];
    }
}

#pragma mark - lazy load

- (VideoPlayerView *)playerView
{
    if (!_playerView) {
        _playerView = [[VideoPlayerView alloc] initWithFrame:PltScreenBounds];
    }
    return _playerView;
}

@end
