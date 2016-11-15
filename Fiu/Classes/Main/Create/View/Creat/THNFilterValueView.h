//
//  THNFilterValueView.h
//  Fiu
//
//  Created by FLYang on 2016/11/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@interface THNFilterValueView : UIView

@pro_strong UILabel *valueTitle;    //  数值标题
@pro_strong UIButton *cancelBtn;    //  取消
@pro_strong UIButton *sureBtn;      //  确定
@pro_strong UISlider *valueSlider;  //  数值调整
@pro_strong UIView *sliderBack;

@end
