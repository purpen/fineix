//
//  GroupHeaderView.h
//  Fiu
//
//  Created by FLYang on 16/4/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@interface GroupHeaderView : UIView

@pro_strong UINavigationController  *   nav;
/**
 *  查看全部打开的类型
 *  0:  全部情景
 *  1:  最Fiu头像列表
 *  2:  全部品牌列表
 */
@pro_assign NSInteger                   openType;
@pro_strong UIButton                *   icon;             //    分组图标
@pro_strong UILabel                 *   headerTitle;      //    头部标题
@pro_strong UILabel                 *   subTitle;         //    副标题
@pro_strong UIButton                *   moreBtn;          //    查看全部

- (void)addGroupHeaderViewIcon:(NSString *)image
                     withTitle:(NSString *)title
                  withSubtitle:(NSString *)subTitle
                 withRightMore:(NSString *)more
                  withMoreType:(NSInteger)openType;

@end
