//
//  BindIngViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/4/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UMSocialAccountEntity;

@interface BindIngViewController : UIViewController
@property(nonatomic ,strong) UMSocialAccountEntity *snsAccount;
@property(nonatomic, strong) NSNumber *type;
@end
