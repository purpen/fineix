//
//  FBFootView.h
//  fineix
//
//  Created by FLYang on 16/2/27.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fineix.h"

@protocol FBFootViewDelegate <NSObject>

@optional

- (void)buttonDidSeletedWithIndex:(NSInteger)index;

@end

@interface FBFootView : UIView

@pro_strong UIScrollView    *   buttonView;         //  按钮视图
@pro_strong NSArray         *   titleArr;           //  底部按钮标题
@pro_strong UILabel         *   line;               //  导航条
@pro_strong UIButton        *   seletedBtn;         //  保存上次点击的button

@pro_assign NSInteger           titleFontSize;      //  标题字号大小
@pro_strong UIColor         *   titleNormalColor;   //  标题默认颜色
@pro_strong UIColor         *   titleSeletedColor;  //  标题点击颜色
@pro_strong UIColor         *   btnBgColor;         //  按钮背景颜色

@pro_weak id <FBFootViewDelegate> delegate;

//  添加按钮
- (void)addFootViewButton;

//  是否显示导航条
- (void)showLineWithButton;

@end
