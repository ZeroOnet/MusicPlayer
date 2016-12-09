//
//  Music.h
//  MusicPlayer
//
//  Created by FunctionMaker on 2016/11/2.
//  Copyright © 2016年 FunctionMaker. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MusicSwithDelegate <NSObject>

@required

- (void)switchMusicWithCurrentIndex:(NSInteger)currentIndex DestinedIndex:(NSInteger)destinedIndex;

@end

@interface Music : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *filename;
@property (nonatomic, copy) NSString *lrcname;
@property (nonatomic, copy) NSString *singer;
@property (nonatomic, copy) NSString *singerIcon;

@property (nonatomic, weak) id<MusicSwithDelegate> delegate;

@property (nonatomic, assign, getter=isPlaying) BOOL playing;

+ (NSArray<Music *> *)musicsWithFileName:(NSString *)fileName;

@end
