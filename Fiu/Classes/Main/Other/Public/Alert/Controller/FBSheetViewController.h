//
//  FBSheetViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/4/19.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBSheetViewController : UIViewController

@property(nonatomic,strong) UIView *sheetView;

-(void)initFBSheetVCWithNameAry:(NSArray*)ary;

@end
