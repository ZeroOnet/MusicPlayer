//
//  LyricLines.m
//  MusicPlayer
//
//  Created by FunctionMaker on 2016/11/5.
//  Copyright © 2016年 FunctionMaker. All rights reserved.
//

#import "LyricLines.h"
#import "TimeConvertTool.h"

@implementation LyricLines

+ (NSMutableArray<LyricLines *> *)lyricLinesWithFileName:(NSString *)fileName {
    NSMutableArray<LyricLines *> *lyricLines = [NSMutableArray array];
    
    NSURL *lyricsUrl = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
    NSString *lyrics = [NSString stringWithContentsOfURL:lyricsUrl encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *lyricsComponents = [lyrics componentsSeparatedByString:@"\n"];
    [lyricsComponents enumerateObjectsUsingBlock:^(NSString *line, NSUInteger idx, BOOL * _Nonnull stop) {
        LyricLines *lyricLine = [[LyricLines alloc] init];
        
        if ([line hasPrefix:@"[ti:"] || [line hasPrefix:@"[ar:"] || [line hasPrefix:@"[al:"]) {
            NSString *words = [[line componentsSeparatedByString:@":"] lastObject];
            lyricLine.word = [words substringToIndex:words.length - 1];
        } else if ([line hasPrefix:@"["]) {
            NSArray *lines = [line componentsSeparatedByString:@"]"];
            NSString *time = [[lines firstObject] substringFromIndex:1];
            
            lyricLine.time = [TimeConvertTool timeWithTimeDetailString:time];
            lyricLine.word = [lines lastObject];
            
            CGRect stringRect = [[lines lastObject] boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.0f]} context:nil];
            
            lyricLine.stringRect = stringRect;
        }
        
        [lyricLines addObject:lyricLine];
    }];
    
    for (int i = 0; i < lyricLines.count; i ++) {
        if (i + 1 < lyricLines.count) {
            lyricLines[i].gradientTime = fabs(lyricLines[i].time - lyricLines[i + 1].time);
        }
    }

    if (lyricLines.count == 0) {
        return nil;
    } else {
        return lyricLines;
    }
}

@end
