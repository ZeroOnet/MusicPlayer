//
//  MusicTool.h
//  MusicPlayer
//
//  Created by FunctionMaker on 2016/11/2.
//  Copyright © 2016年 FunctionMaker. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Music;

@interface MusicTool : NSObject

+ (NSArray<Music *> *)musics;

+ (Music *)playingMusic;
+ (void)setPlayingMusic:(Music *)playingMusic;

+ (Music *)previousMusic;
+ (Music *)nextMusic;

@end
