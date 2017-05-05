//
//  THNEditChildUserInfoViewController.h
//  Fiu
//
//  Created by FLYang on 2017/5/5.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "THNChildUserModel.h"

@interface THNEditChildUserInfoViewController : THNViewController <
    THNNavigationBarItemsDelegate,
    UITextFieldDelegate
>

@property (nonatomic, strong) NSString *childId;
@property (nonatomic, strong) FBRequest *editRequest;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *scaleField;

- (void)thn_setEditUserInfo:(THNChildUserModel *)model;

@end
