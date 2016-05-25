//
//  FindFriendModel.h
//  Fiu
//
//  Created by THN-Dong on 16/4/30.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindFriendModel : NSObject

@property(nonatomic,copy) NSString *avatarUrl;
@property(nonatomic,copy) NSString *nickName;
@property(nonatomic,strong) NSArray *address;
@property(nonatomic,strong) NSNumber *userid;
@property(nonatomic,strong) NSNumber *isLove;
@property(nonatomic,strong) NSMutableArray *scene;
@property(nonatomic,strong) NSNumber *flag;
@property(nonatomic,copy) NSString *label;
@property(nonatomic,strong) NSNumber *level;
@property(nonatomic,strong) NSNumber *is_expert;

@end
