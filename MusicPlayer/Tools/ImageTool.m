//
//  ImageTool.m
//  MusicPlayer
//
//  Created by FunctionMaker on 2016/11/2.
//  Copyright © 2016年 FunctionMaker. All rights reserved.
//

#import "ImageTool.h"

@implementation ImageTool

+ (UIImage *)circleImageWithName:(NSString *)imageName BorderWidth:(CGFloat)borderWidth BorderColor:(UIColor *)borderColor {
    UIImage *originalImage = [UIImage imageNamed:imageName];
    
    CGFloat imageW = originalImage.size.width + 2 * borderWidth;
    CGFloat imageH = originalImage.size.height + 2 * borderWidth;
    
    CGSize imageSize = CGSizeMake(imageW, imageH);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [borderColor set];
    
    CGFloat externalRadius = imageW * 0.5;
    CGFloat centerX = externalRadius;
    CGFloat centerY = externalRadius;
    CGContextAddArc(ctx, centerX, centerY, externalRadius, 0, 2 * M_PI, 0);
    
    CGContextFillPath(ctx);
    
    CGFloat internalRadius = externalRadius - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, internalRadius, 0, 2 * M_PI, 0);
    CGContextClip(ctx);
    
    [originalImage drawInRect:CGRectMake(borderWidth, borderWidth, originalImage.size.width, originalImage.size.height)];
    
    UIImage *objectiveImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    return objectiveImage;
}

@end
