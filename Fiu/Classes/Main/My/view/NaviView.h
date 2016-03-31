//
//  NaviView.h
//  Fiu
//
//  Created by THN-Dong on 16/3/31.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NaviView : UIView

@property (weak, nonatomic) IBOutlet UIButton *camerlBtn;//相机按钮
@property (weak, nonatomic) IBOutlet UIButton *calendarBtn;//日历按钮

+(instancetype)getNaviView;

@end
