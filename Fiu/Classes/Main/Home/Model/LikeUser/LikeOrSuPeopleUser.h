//
//	LikeOrSuPeopleUser.h
// on 3/5/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "LikeOrSuPeopleCounter.h"

@interface LikeOrSuPeopleUser : NSObject

@property (nonatomic, strong) NSString * account;
@property (nonatomic, strong) NSString * avatarUrl;
@property (nonatomic, strong) LikeOrSuPeopleCounter * counter;
@property (nonatomic, assign) NSInteger fansCount;
@property (nonatomic, assign) NSInteger followCount;
@property (nonatomic, assign) NSInteger loveCount;
@property (nonatomic, strong) NSString * nickname;
@property (nonatomic, strong) NSObject * summary;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString * userRank;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end