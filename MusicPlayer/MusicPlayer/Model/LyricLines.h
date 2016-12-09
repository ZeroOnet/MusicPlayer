//
//  LyricLines.h
//  MusicPlayer
//
//  Created by FunctionMaker on 2016/11/5.
//  Copyright © 2016年 FunctionMaker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LyricLines : NSObject

@property (copy, nonatomic) NSString *word;

@property (assign, nonatomic) CGFloat gradientTime;
@property (assign, nonatomic) CGFloat time;
@property (assign, nonatomic) CGRect stringRect;

+ (NSMutableArray<LyricLines *> *)lyricLinesWithFileName:(NSString *)fileName;

@end
