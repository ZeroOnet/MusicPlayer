//
//  LyricCell.h
//  MusicPlayer
//
//  Created by FunctionMaker on 2016/11/6.
//  Copyright © 2016年 FunctionMaker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LyricLines;

@interface LyricCell : UITableViewCell

@property (strong, nonatomic) LyricLines *lyricLine;

@property (assign, nonatomic) BOOL shouldGradient;

+ (NSString *)reuseID;

@end
