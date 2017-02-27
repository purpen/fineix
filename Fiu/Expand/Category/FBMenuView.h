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

@property (nonatomic, strong) UIScrollView            *menuRollView;   //  滑动视图
@property (nonatomic, strong) UILabel                 *line;           //  底部导航线
@property (nonatomic, strong) UILabel                 *viewLine;       //  视图分割线
@property (nonatomic, strong) NSArray                 *menuTitle;      //  导航按钮名称
@property (nonatomic, strong) NSMutableArray          *btnMarr;        //  全部按钮
@property (nonatomic, strong) NSArray                 *widthArr;       //  动态宽度
@property (nonatomic, strong) NSString                *defaultColor;
@property (nonatomic, strong) UIButton                *selectedBtn;
@property (nonatomic, strong) UIButton                *nowSelectedBtn;
@property (nonatomic, weak) id <FBMenuViewDelegate> delegate;

- (void)updateMenuButtonData;

- (void)updateMenuBtnState:(NSInteger)index;

@end
