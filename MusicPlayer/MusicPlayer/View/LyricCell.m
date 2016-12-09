//
//  LyricCell.m
//  MusicPlayer
//
//  Created by FunctionMaker on 2016/11/6.
//  Copyright © 2016年 FunctionMaker. All rights reserved.
//

#import "LyricCell.h"
#import "LyricLines.h"

@interface LyricCell ()

@property (strong, nonatomic) UILabel *frontLabel;

@property (strong, nonatomic) CAKeyframeAnimation *widthAni;
@property (strong, nonatomic) CALayer *gradientMaskLayer;

@end

static NSString *const lyricCellID = @"LYRIC_CELL";

@implementation LyricCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = [UIFont systemFontOfSize:13.0f];
        self.textLabel.numberOfLines = 0;
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.bounds = self.bounds;
}

+ (NSString *)reuseID {
    return lyricCellID;
}

- (void)setLyricLine:(LyricLines *)lyricLine {
    _lyricLine = lyricLine;
    self.textLabel.text = lyricLine.word;
}

- (void)setShouldGradient:(BOOL)shouldGradient {
    if (shouldGradient) {
        [self.contentView addSubview:self.frontLabel];

        self.frontLabel.frame = _lyricLine.stringRect;
        self.frontLabel.center = self.contentView.center;

        self.frontLabel.text = _lyricLine.word;

        self.gradientLayer.position = CGPointMake(0, self.frontLabel.bounds.size.height / 2);
        self.gradientLayer.bounds = CGRectMake(0, 0, 0, self.frontLabel.bounds.size.height);

        self.frontLabel.layer.mask = self.gradientMaskLayer;

        self.widthAni.values = @[@0, @(self.frontLabel.bounds.size.width)];
        self.widthAni.duration = _lyricLine.gradientTime;
        
        [self.gradientMaskLayer addAnimation:self.widthAni forKey:@"widthAnimation"];
    } else {
        if ([self.contentView.subviews containsObject:self.frontLabel]) {
            [self.frontLabel removeFromSuperview];
        }
    }
}

- (UILabel *)frontLabel {
    if (!_frontLabel) {
        _frontLabel = [[UILabel alloc] init];
        _frontLabel.textColor = [UIColor purpleColor];
        _frontLabel.font = [UIFont systemFontOfSize:13.0f];
        _frontLabel.textAlignment = NSTextAlignmentCenter;
        _frontLabel.numberOfLines = 0;
    }
    
    return _frontLabel;
}

- (CAKeyframeAnimation *)widthAni {
    if (!_widthAni) {
        _widthAni = [CAKeyframeAnimation animationWithKeyPath:@"bounds.size.width"];
        _widthAni.calculationMode = kCAAnimationLinear;
        _widthAni.fillMode = kCAFillModeForwards;
        _widthAni.removedOnCompletion = NO;
    }
    
    return _widthAni;
}

- (CALayer *)gradientLayer {
    if (!_gradientMaskLayer) {
        _gradientMaskLayer = [CALayer layer];
        _gradientMaskLayer.anchorPoint = CGPointMake(0, 0.5);
        _gradientMaskLayer.backgroundColor = [UIColor whiteColor].CGColor;
    }
    
    return _gradientMaskLayer;
}



@end
