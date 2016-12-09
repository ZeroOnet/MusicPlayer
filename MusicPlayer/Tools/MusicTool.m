//
//  MusicTool.m
//  MusicPlayer
//
//  Created by FunctionMaker on 2016/11/2.
//  Copyright © 2016年 FunctionMaker. All rights reserved.
//

#import "MusicTool.h"
#import "Music.h"

static Music *_playingMusic;

@implementation MusicTool

+ (NSArray<Music *> *)musics {
    static NSArray *_musics = nil;
    if (!_musics) {
        _musics = [Music musicsWithFileName:@"Musics.plist"];
    }
    
    return _musics;
}

+ (Music *)playingMusic {
    return _playingMusic;
}

+ (void)setPlayingMusic:(Music *)playingMusic {
    if (playingMusic == nil || ![[self musics] containsObject:playingMusic] || playingMusic == _playingMusic) {
        return;
    }
    
    _playingMusic = playingMusic;
}

+ (Music *)previousMusic {
    NSInteger previousIndex = 0;
    
    if (_playingMusic) {
        NSInteger playingIndex = [[self musics] indexOfObject:_playingMusic];
        previousIndex = playingIndex - 1;
        
        if (previousIndex < 0) {
            previousIndex = [self musics].count - 1;
        }
        
        _playingMusic.playing = NO;
        [self musics][previousIndex].playing = YES;
        
        if ([_playingMusic.delegate respondsToSelector:@selector(switchMusicWithCurrentIndex:DestinedIndex:)]) {
            [_playingMusic.delegate switchMusicWithCurrentIndex:playingIndex DestinedIndex:previousIndex];
        }
    }
    
    return [self musics][previousIndex];
}

+ (Music *)nextMusic {
    NSInteger nextIndex = 0;
    
    if (_playingMusic) {
        NSInteger playingIndex = [[self musics] indexOfObject:_playingMusic];
        nextIndex = playingIndex + 1;
        
        if (nextIndex > [self musics].count - 1) {
            nextIndex = 0;
        }
        
        _playingMusic.playing = NO;
        [self musics][nextIndex].playing = YES;
        
        if ([_playingMusic.delegate respondsToSelector:@selector(switchMusicWithCurrentIndex:DestinedIndex:)]) {
            [_playingMusic.delegate switchMusicWithCurrentIndex:playingIndex DestinedIndex:nextIndex];
        }
    }
    
    return [self musics][nextIndex];
}

@end
