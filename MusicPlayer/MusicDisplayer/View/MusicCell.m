//
//  MusicCell.m
//  MusicPlayer
//
//  Created by FunctionMaker on 2016/11/2.
//  Copyright © 2016年 FunctionMaker. All rights reserved.
//

#import "MusicCell.h"
#import "Music.h"
#import "ImageTool.h"

static NSString *const musicID = @"MUSIC_ID";

@implementation MusicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    
    return self;
}

+ (NSString *)reuseID {
    return musicID;
}

- (void)setMusic:(Music *)music {
    _music = music;
    
    self.textLabel.text = music.name;
    self.detailTextLabel.text = music.singer;
    
    if (music.isPlaying) {
        self.imageView.image = [ImageTool circleImageWithName:music.singerIcon BorderWidth:2.0f BorderColor:[UIColor colorWithRed:252.0f / 255.0f green:230.0f / 255.0f blue:201.0f / 255.0f alpha:1.0f]];
    } else {
        self.imageView.image = [ImageTool circleImageWithName:music.singerIcon BorderWidth:2.0f BorderColor:[UIColor colorWithRed:255.0f / 255.0f green:95.0f / 255.0f blue:154.0f / 255.0f alpha:1.0f]];
    }
}

@end
