//
//  FBSticker.h
//  Fiu
//
//  Created by FLYang on 16/5/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Fiu.h"

@interface FBSticker : NSObject

@pro_assign CGFloat         rotateAngle;
@pro_assign CGPoint         translateCenter;
@pro_assign CGSize          size;
@pro_strong UIImage     *   image;
@pro_assign CGSize          containerSize;

@end
