//
//  FBSegmentView.h
//  Fiu
//
//  Created by FLYang on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@protocol FBSegmentViewDelegate <NSObject>

@optional
- (void)menuItemSelected:(NSInteger)index;

@end

@interface FBSegmentView : UIView

@pro_strong UIButton *selectedBtn;
@pro_strong UILabel *bottomLine;
@pro_strong NSArray *title;
@pro_strong NSMutableArray *btnMarr;

- (void)set_menuItemTitle:(NSArray *)titleArr;
- (void)set_showBottomLine:(BOOL)show;
- (void)updateMenuBtnState:(NSInteger)index;
- (void)addViewBottomLine;

@pro_weak id <FBSegmentViewDelegate> delegate;

@end
