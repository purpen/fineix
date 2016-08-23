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

- (void)set_menuItemTitle:(NSArray *)titleArr;
- (void)set_showBottomLine:(BOOL)show;

@pro_weak id <FBSegmentViewDelegate> delegate;

@end
