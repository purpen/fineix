//
//  BottomView.h
//  Fiu
//
//  Created by THN-Dong on 16/3/31.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomView : UIView
@property (weak, nonatomic) IBOutlet UIButton *aboutUsBtn;
@property (weak, nonatomic) IBOutlet UIButton *opinionBtn;
@property (weak, nonatomic) IBOutlet UIButton *partnerBtn;

+(instancetype)getBottomView;

@end
