//
//  BrandListModel.m
//  Fiu
//
//  Created by FLYang on 16/7/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "BrandListModel.h"

@implementation BrandListModel

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(![dictionary[@"_id"] isKindOfClass:[NSNull class]]){
        self.brandId = dictionary[@"_id"];
    }
    
    if(![dictionary[@"kind"] isKindOfClass:[NSNull class]]){
        self.kind = [dictionary[@"kind"] integerValue];
    }
    
    if(![dictionary[@"self_run"] isKindOfClass:[NSNull class]]){
        self.selfRun = [dictionary[@"self_run"] integerValue];
    }
    
    if(![dictionary[@"cover_url"] isKindOfClass:[NSNull class]]){
        self.coverUrl = dictionary[@"cover_url"];
    }
    if(![dictionary[@"banner_url"] isKindOfClass:[NSNull class]]){
        self.bannerUrl = dictionary[@"banner_url"];
    }
    if(![dictionary[@"mark"] isKindOfClass:[NSNull class]]){
        self.mark = dictionary[@"mark"];
    }
    
    if(![dictionary[@"kind_label"] isKindOfClass:[NSNull class]]){
        self.kindLabel = dictionary[@"kind_label"];
    }
    
    if(![dictionary[@"created_on"] isKindOfClass:[NSNull class]]){
        self.createdOn = [dictionary[@"created_on"] integerValue];
    }
    
    if(![dictionary[@"des"] isKindOfClass:[NSNull class]]){
        self.des = dictionary[@"des"];
    }
    if(![dictionary[@"content"] isKindOfClass:[NSNull class]]){
        self.content = dictionary[@"content"];
    }
    if(![dictionary[@"status"] isKindOfClass:[NSNull class]]){
        self.status = [dictionary[@"status"] integerValue];
    }
    
    if(![dictionary[@"stick"] isKindOfClass:[NSNull class]]){
        self.stick = dictionary[@"stick"];
    }
    if(![dictionary[@"title"] isKindOfClass:[NSNull class]]){
        self.title = dictionary[@"title"];
    }
    if(![dictionary[@"updated_on"] isKindOfClass:[NSNull class]]){
        self.updatedOn = [dictionary[@"updated_on"] integerValue];
    }
    
    if(![dictionary[@"used_count"] isKindOfClass:[NSNull class]]){
        self.usedCount = [dictionary[@"used_count"] integerValue];
    }
    
    return self;
}

@end
