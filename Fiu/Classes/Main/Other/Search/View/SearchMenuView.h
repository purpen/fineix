//
//  SearchMenuView.h
//  Fiu
//
//  Created by FLYang on 16/4/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@protocol SearchMenuBtnSelectedDelegate <NSObject>

@required
- (void)SearchMenuSeleted:(NSInteger)index;

@end

@interface SearchMenuView : UIView

@pro_strong UIButton        *   selectedBtn;
@pro_strong UILabel         *   menuBottomline;     //  导航底部条
@pro_strong UILabel         *   line;               //  分割线

@pro_weak   id <SearchMenuBtnSelectedDelegate>  delegate;

- (void)setSearchMenuView:(NSArray *)title;

@end
