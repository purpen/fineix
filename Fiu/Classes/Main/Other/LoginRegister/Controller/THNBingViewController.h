//
//  THNBingViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/8/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMSocialCore/UMSocialCore.h>

@interface THNBingViewController : UIViewController
@property(nonatomic ,strong) UMSocialUserInfoResponse *snsAccount;
@property(nonatomic, strong) NSNumber *type;
@end
