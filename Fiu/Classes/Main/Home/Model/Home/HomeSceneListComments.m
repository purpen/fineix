//
//  HomeSceneListComments.m
//  Fiu
//
//  Created by FLYang on 16/8/10.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "HomeSceneListComments.h"

NSString *const kHomeSceneListCommentIdField = @"_id";
NSString *const kHomeSceneListCommentContent = @"content";
NSString *const kHomeSceneListCommentUserAvatarUrl = @"user_avatar_url";
NSString *const kHomeSceneListCommentUserId = @"user_id";
NSString *const kHomeSceneListCommentUserNickname = @"user_nickname";

@implementation HomeSceneListComments

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[kHomeSceneListCommentIdField] isKindOfClass:[NSNull class]]){
        self.idField = dictionary[kHomeSceneListCommentIdField];
    }
    if(![dictionary[kHomeSceneListCommentContent] isKindOfClass:[NSNull class]]){
        self.content = dictionary[kHomeSceneListCommentContent];
    }
    if(![dictionary[kHomeSceneListCommentUserAvatarUrl] isKindOfClass:[NSNull class]]){
        self.userAvatarUrl = dictionary[kHomeSceneListCommentUserAvatarUrl];
    }
    if(![dictionary[kHomeSceneListCommentUserId] isKindOfClass:[NSNull class]]){
        self.userId = [dictionary[kHomeSceneListCommentUserId] integerValue];
    }
    
    if(![dictionary[kHomeSceneListCommentUserNickname] isKindOfClass:[NSNull class]]){
        self.userNickname = dictionary[kHomeSceneListCommentUserNickname];
    }	
    return self;
}

@end
