//
//  ProjectModel.h
//  Fiu
//
//  Created by THN-Dong on 16/6/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ProjectLove = 1,
    ProjectNotLove = 0
} ProjectLoveType;

@interface ProjectModel : NSObject

/** 喜欢专题的总人数 */
@property (nonatomic, strong) NSNumber *love_count;
/** 是否喜欢该专题 */
@property (nonatomic, assign) ProjectLoveType is_love;
/** h5链接 */
@property(nonatomic,copy) NSString *content_view_url;
/** 专题的标题 */
@property(nonatomic,copy) NSString *title;
/** 创建专题的人的id */
@property(nonatomic,copy) NSString *personId;
/** 评论的人数 */
@property (nonatomic, strong) NSNumber *comment_count;
/** 分享的链接 */
@property(nonatomic,copy) NSString *share_view_url;
/** 分享的内容 */
@property(nonatomic,copy) NSString *share_desc;
/** 分享里的图片 */
@property(nonatomic,copy) NSString *cover_url;

+(instancetype)projectWithDict:(NSDictionary*)dict;

@end
