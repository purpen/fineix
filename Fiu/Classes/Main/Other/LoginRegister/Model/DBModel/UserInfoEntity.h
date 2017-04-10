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
@property (nonatomic, copy) NSString * label;
@property (nonatomic, strong) NSNumber * birdCoin;
@property (nonatomic, copy) NSString * summary;
@property(nonatomic,copy) NSString *city;
@property(nonatomic,copy) NSString *prin;
@property(nonatomic,copy) NSString *follow_count;
@property(nonatomic,copy) NSString *head_pic_url;
@property(nonatomic,assign) NSInteger is_love;
@property(nonatomic,copy) NSString *is_expert;
@property(nonatomic,copy) NSString *expert_label;
@property(nonatomic,copy) NSString *expert_info;
/** 年龄段 */
@property(nonatomic,copy) NSString *age_group;
/** 资产 */
@property(nonatomic,copy) NSString *assets;
/** 订阅的情境主题 */
@property (nonatomic, copy) NSString *interest_scene_cate;

/**
 是否送红包
 */
@property (nonatomic, assign) NSInteger is_bonus;

/**
 联盟用户id
 */
@property (nonatomic, strong) NSString *allianceId;

/**
 地盘id
 */
@property (nonatomic, strong) NSString *storageId;

/**
 注册日期
 */
@property (nonatomic, strong) NSString *created_on;

+ (instancetype)defaultUserInfoEntity;
- (void)updateUserInfo;
- (void)clear;

@end
