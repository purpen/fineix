//
//  HomeSceneListComments.h
//  Fiu
//
//  Created by FLYang on 16/8/10.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeSceneListComments : NSObject

@property (nonatomic, strong) NSString * commentId;
@property (nonatomic, strong) NSString * avatarUrl;
@property (nonatomic, strong) NSString * nickname;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, assign) NSInteger userId;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
