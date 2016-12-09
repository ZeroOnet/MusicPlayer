//
//  LyricsViewController.h
//  MusicPlayer
//
//  Created by FunctionMaker on 2016/12/9.
//  Copyright © 2016年 FunctionMaker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LyricsViewController : UIViewController

@property (assign, nonatomic) NSTimeInterval currentTime;
@property (copy, nonatomic) NSString *fileName;

@end
