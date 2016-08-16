//
//  FBImageScrollView.h
//  Fiu
//
//  Created by FLYang on 16/8/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBImageScrollView : UIScrollView

- (void)displayImage:(UIImage *)image;

- (UIImage *)capture;

@end
