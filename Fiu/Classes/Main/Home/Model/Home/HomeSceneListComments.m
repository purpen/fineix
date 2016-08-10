//
//  HomeSceneListComments.m
//  Fiu
//
//  Created by FLYang on 16/8/10.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "HomeSceneListComments.h"

@implementation HomeSceneListComments

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[@"_id"] isKindOfClass:[NSNull class]]){
        self.commentId = dictionary[@"_id"];
    }
    if(![dictionary[@"user_avatar_url"] isKindOfClass:[NSNull class]]){
        self.avatarUrl = dictionary[@"user_avatar_url"];
    }

    if(![dictionary[@"user_nickname"] isKindOfClass:[NSNull class]]){
        self.nickname = dictionary[@"user_nickname"];
    }
    
    if(![dictionary[@"content"] isKindOfClass:[NSNull class]]){
        self.content = dictionary[@"content"];
    }
    
    if(![dictionary[@"user_id"] isKindOfClass:[NSNull class]]){
        self.userId = [dictionary[@"user_id"] integerValue];
    }
    return self;
}

@end
