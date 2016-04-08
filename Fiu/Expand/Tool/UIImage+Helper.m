//
//  UIImage+Helper.m
//  FLyang
//
//  Created by FLyang on 15/3/31.
//  Copyright (c) 2015年 FLyang. All rights reserved.
//s

#import "UIImage+Helper.h"

@implementation UIImage (Helper)

#pragma mark 默认从图片中心点开始拉伸图片
+ (UIImage *)resizedImage:(NSString *)imgName {
    return [self resizedImage:imgName xPos:0.5 yPos:0.5];
}

#pragma mark 可以自由拉伸的图片
+ (UIImage *)resizedImage:(NSString *)imgName xPos:(CGFloat)xPos yPos:(CGFloat)yPos {
    UIImage *image = [UIImage imageNamed:imgName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * xPos topCapHeight:image.size.height * yPos];
}


@end
