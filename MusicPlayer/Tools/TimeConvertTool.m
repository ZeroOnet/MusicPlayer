//
//  TimeConvertTool.m
//  MusicPlayer
//
//  Created by FunctionMaker on 2016/11/12.
//  Copyright © 2016年 FunctionMaker. All rights reserved.
//

#import "TimeConvertTool.h"

@implementation TimeConvertTool

+ (NSString *)timeNormalStringWithTime:(NSTimeInterval)time {
    NSInteger minute = time / 60;
    NSInteger second = time - minute * 60;//should avoid using Mod division directly
    
    NSString *timeNormalString = [NSString stringWithFormat:@"%02zd:%02zd", minute, second];
    
    return timeNormalString;
}

+ (NSTimeInterval)timeWithTimeDetailString:(NSString *)timeDetailString {
    NSArray *timeComponents = [timeDetailString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":."]];
    
    NSInteger minute = [timeComponents[0] integerValue];
    NSInteger second = [timeComponents[1] integerValue];
    NSInteger msecond = [timeComponents[2] integerValue];
    
    NSTimeInterval time = minute * 60 + second + msecond * 0.01;
    
    return time;
}

@end
