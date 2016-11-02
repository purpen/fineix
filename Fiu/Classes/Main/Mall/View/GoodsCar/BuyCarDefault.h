//
//  BuyCarDefault.h
//  Fiu
//
//  Created by FLYang on 16/4/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@interface BuyCarDefault : UIView

@pro_strong UINavigationController *nav;
@pro_strong UIImageView *defaultImg;
@pro_strong UILabel *promptLab;
@pro_strong UIButton *defaultBtn;
@pro_strong UIView *whiteView;

/**
 设置默认提示视图

 @param imageName  提示图片
 @param promptText 提示文字
 @param isShowButton 显示按钮
 */
- (void)thn_setDefaultViewImage:(NSString *)imageName promptText:(NSString *)promptText showButton:(BOOL)isShowButton;

@end
