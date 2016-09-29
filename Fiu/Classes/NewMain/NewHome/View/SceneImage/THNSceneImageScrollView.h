//
//  THNSceneImageScrollView.h
//  Fiu
//
//  Created by FLYang on 16/9/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface THNSceneImageScrollView : UIScrollView <
    UIScrollViewDelegate
>

- (void)displayImage:(UIImage *)image;

- (void)networkDisplayImage:(NSString *)imageUrl;

@end
