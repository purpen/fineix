//
//	SceneInfoUserInfo.h
// on 25/4/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "SceneInfoCounter.h"

@interface SceneInfoUserInfo : NSObject

@property (nonatomic, strong) NSString * account;
@property (nonatomic, strong) NSString * avatarUrl;
@property (nonatomic, strong) SceneInfoCounter * counter;
@property (nonatomic, assign) NSInteger fansCount;
@property (nonatomic, assign) NSInteger followCount;
@property (nonatomic, assign) NSInteger loveCount;
@property (nonatomic, strong) NSString * nickname;
@property (nonatomic, strong) NSString * summary;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString * userRank;
@property (nonatomic, strong) NSString * userLable;
@property (nonatomic, strong) NSString * expertLabel;
@property (nonatomic, assign) NSInteger isExpert;
@property (nonatomic, strong) NSString * expertInfo;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end