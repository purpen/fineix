//
//  ShareViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/4/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UMSocialSnsData;

@interface ShareViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIView *wechatView;
@property (weak, nonatomic) IBOutlet UIButton *friendBtn;
@property (weak, nonatomic) IBOutlet UIView *friendView;
@property (weak, nonatomic) IBOutlet UIButton *weiBoBtn;
@property (weak, nonatomic) IBOutlet UIView *weiBoView;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UIView *qqView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *otherBtn;

@end
