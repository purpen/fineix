//
//  UserInfo.m
//  fineix
//
//  Created by THN-Dong on 16/3/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "UserInfo.h"
#import "UserInfoEntity.h"

@implementation UserInfo

-(void)updateUserInfoEntity{
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    UserInfo *userInfo = [[UserInfo findAll] lastObject];
    entity.pk = userInfo.pk;
    
    entity.userId = userInfo.userId;
    entity.account = userInfo.account;
    entity.nickname = userInfo.nickname;
    entity.trueNickname = userInfo.trueNickname;
    entity.firstLogin = userInfo.firstLogin;
    entity.sex = userInfo.sex;
    entity.mediumAvatarUrl = userInfo.mediumAvatarUrl;
    entity.birthday = userInfo.birthday;
    entity.level = userInfo.level;
    entity.levelDesc = userInfo.levelDesc;
    entity.birdCoin = userInfo.birdCoin;
    entity.summary = userInfo.summary;
    
    entity.city = userInfo.city;
    entity.areas = userInfo.areas;
    entity.follow_count = userInfo.follow_count;
    entity.head_pic_url = userInfo.head_pic_url;
    entity.is_love = userInfo.is_love;
}

@end
