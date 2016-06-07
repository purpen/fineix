//
//  SexSheetViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/6/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"

@interface SexSheetViewController : FBViewController
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIPickerView *sexPickerView;
@property (nonatomic, strong) NSNumber  * sexNum;

@end
