//
//  THNSceneImageScrollView.h
//  Fiu
//
//  Created by FLYang on 16/9/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@interface THNSceneImageScrollView : UIScrollView <
    UIScrollViewDelegate
>

- (void)displayImage:(NSString *)imageUrl;

@end
