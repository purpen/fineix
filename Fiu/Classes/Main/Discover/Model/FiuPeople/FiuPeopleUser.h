//
//	FiuPeopleUser.h
// on 14/5/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "FiuPeopleCounter.h"
#import "FiuPeopleIdentify.h"

@interface FiuPeopleUser : NSObject

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSArray * areas;
@property (nonatomic, strong) NSString * birthday;
@property (nonatomic, strong) FiuPeopleCounter * counter;
@property (nonatomic, assign) NSInteger createdOn;
@property (nonatomic, assign) NSInteger districtId;
@property (nonatomic, assign) NSInteger fansCount;
@property (nonatomic, assign) NSInteger firstLogin;
@property (nonatomic, assign) NSInteger followCount;
@property (nonatomic, strong) FiuPeopleIdentify * identify;
@property (nonatomic, strong) NSObject * imQq;
@property (nonatomic, assign) NSInteger isLove;
@property (nonatomic, strong) NSString * mediumAvatarUrl;
@property (nonatomic, strong) NSString * nickname;
@property (nonatomic, assign) NSInteger provinceId;
@property (nonatomic, assign) NSInteger sceneCount;
@property (nonatomic, strong) NSArray * sceneSight;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, assign) NSInteger sightCount;
@property (nonatomic, assign) NSInteger sightLoveCount;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) NSInteger subscriptionCount;
@property (nonatomic, strong) NSString * summary;
@property (nonatomic, strong) NSString * trueNickname;
@property (nonatomic, strong) NSObject * weixin;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end