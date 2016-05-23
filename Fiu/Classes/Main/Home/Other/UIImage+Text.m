//
//  UIImage+Text.m
//  Fiu
//
//  Created by FLYang on 16/5/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "UIImage+Text.h"

@implementation UIImage_Text

- (UIImage *)addText:(UIImage *)img text:(NSString *)mark withRect:(CGRect)rect {
    CGFloat w = img.size.width;
    CGFloat h = img.size.height;
    
    UIGraphicsBeginImageContext(img.size);
    [img drawInRect:CGRectMake(0, 0, w, h)];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:20.0f], NSFontAttributeName,[UIColor blueColor] ,NSForegroundColorAttributeName,nil];
    [mark drawInRect:rect withAttributes:dic];
    UIImage * aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return aimg;
}

@end
