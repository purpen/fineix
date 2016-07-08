//
//  FiuPeopleListRow.h
//  Fiu
//
//  Created by FLYang on 16/7/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FiuPeopleListRow : NSObject

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * avatarUrl;
@property (nonatomic, strong) NSString * nickname;
@property (nonatomic, strong) NSString * summary;
@property (nonatomic, strong) NSString * userLable;
@property (nonatomic, strong) NSString * expertLabel;
@property (nonatomic, strong) NSString * expertInfo;
@property (nonatomic, assign) NSInteger isExpert;
@property (nonatomic, assign) NSInteger userRank;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
