//
//  UserInfoEntity.m
//  fineix
//
//  Created by THN-Dong on 16/3/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "UserInfoEntity.h"
#import "UserInfo.h"

@implementation UserInfoEntity

+(instancetype)defaultUserInfoEntity{
    static UserInfoEntity *entity;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        entity = [[UserInfoEntity alloc] init];
        entity.userId = @"";
    });
    return entity;
}

- (void)updateUserInfo
{
    UserInfo * userInfo = [[UserInfo findAll] lastObject];
    
    userInfo.userId = self.userId;
    userInfo.account = self.account;
    userInfo.nickname = self.nickname;
    userInfo.trueNickname = self.trueNickname;
    userInfo.firstLogin = self.firstLogin;
    userInfo.sex = self.sex;
    userInfo.mediumAvatarUrl = self.mediumAvatarUrl;
    userInfo.birthday = self.birthday;
    userInfo.level = self.level;
    userInfo.label = self.label;
    userInfo.birdCoin = self.birdCoin;
    userInfo.summary = self.summary;
    
    userInfo.city = self.city;
    userInfo.prin = self.prin;
    userInfo.follow_count = self.follow_count;
    userInfo.head_pic_url = self.head_pic_url;
    userInfo.is_love = self.is_love;
    userInfo.isLogin = self.isLogin;
    userInfo.is_expert = self.is_expert;
    userInfo.expert_label = self.expert_label;
    userInfo.expert_info = self.expert_info;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [userInfo saveOrUpdate];
    });
}

-(void)clear{
    self.userId = @"";
    self.account = @"";
    self.nickname = @"";
    self.trueNickname = @"";
    self.sex = @0;
    self.firstLogin = @0;
    self.mediumAvatarUrl = @"";
    self.birthday = @"";
    self.level = @0;
    self.label = @"";
    self.birdCoin = @0;
    self.summary = @"";
    self.city = @"";
    self.prin = @"";
    self.follow_count = @"";
    self.head_pic_url = @"";
    self.is_love = @0;
    self.isLogin = NO;
    self.is_expert = @"0";
    self.expert_label = @"";
    self.expert_info = @"";
}

@end
