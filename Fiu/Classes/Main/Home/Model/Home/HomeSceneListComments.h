//
//  HomeSceneListComments.h
//  Fiu
//
//  Created by FLYang on 16/8/10.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeSceneListComments : NSObject

@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * userAvatarUrl;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString * userNickname;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
