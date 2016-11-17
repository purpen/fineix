//
//  THNFilterValueView.h
//  Fiu
//
//  Created by FLYang on 2016/11/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "FSFliterImage.h"

@protocol ChangeFilterValueDelegate <NSObject>

@optional
//  调整参数值
- (void)thn_changeImageFilterValue:(CGFloat)value;
//  确定修改参数值
- (void)thn_sureChangeFilterValue:(CGFloat)value;
//  取消修改参数值
- (void)thn_cancelChangeFilterValue;

@end

@interface THNFilterValueView : UIView

@pro_strong UILabel *valueTitle;    //  数值标题
@pro_strong UIButton *cancelBtn;    //  取消
@pro_strong UIButton *sureBtn;      //  确定
@pro_strong UISlider *valueSlider;  //  数值调整
@pro_strong UILabel *valueShowLab;  //  显示当前数值
@pro_strong UIView *sliderBack;
@pro_weak id <ChangeFilterValueDelegate> delegate;

- (void)thn_setSliderWithType:(NSInteger)type filterImage:(FSFliterImage *)filterImage;

@end
