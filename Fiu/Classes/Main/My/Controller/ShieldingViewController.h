//
//  ShieldingViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/5/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShieldingViewController : UIViewController
@property(nonatomic,strong) UIView *sheetView;

-(void)initFBSheetVCWithNameAry:(NSArray*)ary;
@end
