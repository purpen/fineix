//
//  UserInfo.h
//  fineix
//
//  Created by THN-Dong on 16/3/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "JKDBModel.h"
#import "MJExtension.h"

@interface UserInfo : JKDBModel

@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * account;
@property (nonatomic, copy) NSString * nickname;
@property (nonatomic, copy) NSString * trueNickname;
@property (nonatomic, strong) NSNumber * firstLogin;
@property (nonatomic, strong) NSNumber * sex;
@property (nonatomic, copy) NSString * mediumAvatarUrl;
@property (nonatomic, copy) NSString * birthday;
@property (nonatomic, strong) NSNumber * level;
@property (nonatomic, copy) NSString * label;
@property (nonatomic, strong) NSNumber * birdCoin;
@property (nonatomic, copy) NSString * summary;
@property (nonatomic, assign) BOOL whetherFocusOn;
@property(nonatomic,copy) NSString *city;
@property(nonatomic,copy) NSString *prin;
@property(nonatomic,copy) NSString *follow_count;
@property(nonatomic,copy) NSString *head_pic_url;
@property(nonatomic,assign) NSInteger is_love;
@property(nonatomic,assign) BOOL isLogin;
@property(nonatomic,copy) NSString *is_expert;
@property(nonatomic,copy) NSString *expert_label;
@property(nonatomic,copy) NSString *expert_info;

- (void)updateUserInfoEntity;

@end
