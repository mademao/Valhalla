//
//  VideoPlayerView.h
//  Valhalla
//
//  Created by mademao on 2018/9/30.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoPlayerView : UIView

/**
 *  加载本地视频
 */
- (void)loadLocalVedioWithURL:(NSString *)urlStr;

/**
 *  加载网络视频
 */
- (void)loadNetVedioWithURL:(NSString *)urlStr;

/**
 *  播放
 */
- (void)play;

/**
 *  暂停
 */
- (void)pause;

@end

NS_ASSUME_NONNULL_END
