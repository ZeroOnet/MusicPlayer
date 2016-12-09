//
//  MusicCell.h
//  MusicPlayer
//
//  Created by FunctionMaker on 2016/11/2.
//  Copyright © 2016年 FunctionMaker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Music;

@interface MusicCell : UITableViewCell

@property (nonatomic, strong) Music *music;

+ (NSString *)reuseID;

@end
