//
//  THNBingViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/8/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UMSocialAccountEntity;

@interface THNBingViewController : UIViewController
@property(nonatomic ,strong) UMSocialAccountEntity *snsAccount;
@property(nonatomic, strong) NSNumber *type;
@end
