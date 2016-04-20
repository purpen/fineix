//
//  FBMenuView.h
//  Fiu
//
//  Created by FLYang on 16/4/19.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@protocol FBMenuViewDelegate <NSObject>

@optional
- (void)menuItemSelectedWithIndex:(NSInteger)index;

@end

@interface FBMenuView : UIView

@pro_strong UIScrollView            *   menuRollView;   //  滑动视图
@pro_strong UILabel                 *   line;           //  底部导航线
@pro_strong UILabel                 *   viewLine;       //  视图分割线
@pro_strong NSArray                 *   menuTitle;      //  导航按钮名称
@pro_strong NSMutableArray          *   btnMarr;        //  全部按钮
@pro_strong NSArray                 *   widthArr;       //  动态宽度
@pro_strong UIButton                *   selectedBtn;
@pro_strong UIButton                *   nowSelectedBtn;
@pro_assign NSInteger                   nowIndex;

@pro_weak id <FBMenuViewDelegate> delegate;

- (void)updateMenuButtonData;

- (void)updateMenuBtnState:(NSInteger)index;

@end
