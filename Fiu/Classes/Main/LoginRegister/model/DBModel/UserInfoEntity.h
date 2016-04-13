//
//  UserInfoEntity.h
//  fineix
//
//  Created by THN-Dong on 16/3/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoEntity : NSObject

@property (nonatomic, assign) int pk;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * account;
@property (nonatomic, copy) NSString * nickname;
@property (nonatomic, copy) NSString * trueNickname;
@property (nonatomic, strong) NSNumber * firstLogin;
@property (nonatomic, strong) NSNumber * sex;
@property (nonatomic, copy) NSString * mediumAvatarUrl;
@property (nonatomic, copy) NSString * birthday;
@property (nonatomic, strong) NSNumber * level;
@property (nonatomic, copy) NSString * levelDesc;
@property (nonatomic, strong) NSNumber * birdCoin;
@property (nonatomic ,copy) NSString *summary;//个人简介

+ (instancetype)defaultUserInfoEntity;
- (void)updateUserInfo;
- (void)clear;

@end
