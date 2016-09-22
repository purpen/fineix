//
//  THNRemindModelCommentObj.m
//  Fiu
//
//  Created by FLYang on 16/9/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNRemindModelCommentObj.h"

@implementation THNRemindModelCommentObj

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[@"_id"] isKindOfClass:[NSNull class]]){
        self.idField = [dictionary[@"_id"] integerValue];
    }
    
    if(![dictionary[@"content"] isKindOfClass:[NSNull class]]){
        self.content = dictionary[@"content"];
    }
    if(![dictionary[@"cover_url"] isKindOfClass:[NSNull class]]){
        self.coverUrl = dictionary[@"cover_url"];
    }	
    return self;
}

@end
