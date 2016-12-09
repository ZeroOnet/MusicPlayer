//
//  TimeConvertTool.h
//  MusicPlayer
//
//  Created by FunctionMaker on 2016/11/12.
//  Copyright © 2016年 FunctionMaker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeConvertTool : NSObject

+ (NSString *)timeNormalStringWithTime:(NSTimeInterval)time;

+ (NSTimeInterval)timeWithTimeDetailString:(NSString *)timeDetailString;

@end
