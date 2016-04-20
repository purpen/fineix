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
@pro_strong UIImageView             *   icon;             //    分组图标
@pro_strong UILabel                 *   headerTitle;      //    头部标题
@pro_strong UILabel                 *   subTitle;         //    副标题
@pro_strong UIButton                *   moreBtn;          //    查看全部

- (void)addLookMoreBtn;

- (void)addGroupHeaderViewIcon:(NSString *)image withTitle:(NSString *)title withSubtitle:(NSString *)subTitle;

@end