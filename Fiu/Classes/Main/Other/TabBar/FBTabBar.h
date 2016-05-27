//
//  FBTabBar.h
//  fineix
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@interface FBTabBar : UITabBar

/**
 *  创建情景按钮
 */
@pro_strong UIButton    *   createBtn;          //  自定义的Button
@pro_strong UILabel     *   createTitle;
@property(nonatomic,strong) UIView *badgeView;

-(void)chang;

@end
