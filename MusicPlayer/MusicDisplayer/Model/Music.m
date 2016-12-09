//
//  Music.m
//  MusicPlayer
//
//  Created by FunctionMaker on 2016/11/2.
//  Copyright © 2016年 FunctionMaker. All rights reserved.
//

#import "Music.h"

@implementation Music

- (instancetype)initWithMusicMsg:(NSDictionary *)musicMsg {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:musicMsg];
    }
    
    return self;
}

+ (NSArray<Music *> *)musicsWithFileName:(NSString *)fileName {
    NSArray *musicsInfo = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:nil]];
    NSMutableArray *musics = [NSMutableArray arrayWithCapacity:musicsInfo.count];
    for (NSDictionary *musicInfo in musicsInfo) {
        Music *music = [[Music alloc] initWithMusicMsg:musicInfo];
        
        [musics addObject:music];
    }
    
    return musics;
}

@end
