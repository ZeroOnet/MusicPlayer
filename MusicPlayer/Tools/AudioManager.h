//
//  AudioManager.h
//  MusicPlayer
//
//  Created by FunctionMaker on 2016/11/5.
//  Copyright © 2016年 FunctionMaker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVAudioPlayer;

@interface AudioManager : NSObject

+ (instancetype)defaultManager;

- (AVAudioPlayer *)playingMusic:(NSString *)fileName;

- (void)pauseMusic;
- (void)stopMusic;

@end
