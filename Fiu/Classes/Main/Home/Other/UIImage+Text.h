//
//  UIImage+Text.h
//  Fiu
//
//  Created by FLYang on 16/5/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIImage_Text : NSObject

/**
 *  图片上加文字
 */
- (UIImage *)addText:(UIImage *)img text:(NSString *)mark withRect:(CGRect)rect;

@end
