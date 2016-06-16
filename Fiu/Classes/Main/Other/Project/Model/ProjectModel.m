//
//  ProjectModel.m
//  Fiu
//
//  Created by THN-Dong on 16/6/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ProjectModel.h"

@implementation ProjectModel

+(instancetype)projectWithDict:(NSDictionary *)dict{
    ProjectModel *model = [[self alloc] init];
    model.love_count = dict[@"love_count"];
    model.is_love = (ProjectLoveType)[dict[@"is_love"] intValue];
    model.content_view_url = dict[@"content_view_url"];
    model.title = dict[@"title"];
    model.personId = dict[@"user_id"];
    model.comment_count = dict[@"comment_count"];
    model.share_view_url = dict[@"share_view_url"];
    return model;
}

@end
