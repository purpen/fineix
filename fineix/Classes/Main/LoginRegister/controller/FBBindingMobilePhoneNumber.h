//
//  FBBindingMobilePhoneNumber.h
//  fineix
//
//  Created by THN-Dong on 16/3/24.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocial.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>

@interface FBBindingMobilePhoneNumber : UIViewController

@property(nonatomic ,strong) UMSocialAccountEntity *snsAccount;
@property(nonatomic, strong) NSNumber *type;

@end
