//
//  AudioManager.m
//  MusicPlayer
//
//  Created by FunctionMaker on 2016/11/5.
//  Copyright © 2016年 FunctionMaker. All rights reserved.
//

#import "AudioManager.h"
#import <AVFoundation/AVFoundation.h>

static AVAudioPlayer *_musicPlayer = nil;
static NSString *_fileName;

@implementation AudioManager

+ (instancetype)defaultManager {
    static AudioManager *_manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _manager = [[AudioManager alloc] init];
    });
    
    return _manager;
}

- (AVAudioPlayer *)playingMusic:(NSString *)fileName {
    if (fileName == nil || fileName.length == 0) {
        return nil;
    }
    
    if ([_fileName isEqualToString:fileName]) {
        if (![_musicPlayer isPlaying]) {
            [_musicPlayer play];
        }
        
        return _musicPlayer;
    } else {
        _fileName = fileName;
        
        NSURL *musicUrl = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        
        if (!musicUrl) {
            return nil;
        }
        
        //_musicPlayer = nil;
        
        _musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicUrl error:nil];
        
        if (![_musicPlayer prepareToPlay]) {
            return nil;
        }
        
        if (!_musicPlayer.isPlaying) {
            [_musicPlayer play];
        }
        
        return _musicPlayer;
    }
}

- (void)pauseMusic {
    if ([_musicPlayer isPlaying]) {
        [_musicPlayer pause];
    }
}

- (void)stopMusic {
    [_musicPlayer stop];
    
    _musicPlayer = nil;
    _fileName = nil;
}

@end
