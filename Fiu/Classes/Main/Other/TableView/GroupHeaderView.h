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

@pro_strong UIImageView             *   icon;             //    分组图标
@pro_strong UILabel                 *   Headertitle;      //    头部标题
@pro_strong UILabel                 *   Subtitle;         //    副标题

- (void)addGroupHeaderViewIcon:(NSString *)image withTitle:(NSString *)title withSubtitle:(NSString *)subTitle;

@end
