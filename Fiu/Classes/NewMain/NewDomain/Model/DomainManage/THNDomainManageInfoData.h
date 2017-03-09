//
//	THNDomainManageInfoData.h
// on 9/3/2017
//	Copyright © 2017. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "THNDomainManageInfoExtra.h"
#import "THNDomainManageInfoLocation.h"
#import "THNDomainManageInfoNCover.h"
#import "THNDomainManageInfoUser.h"

@interface THNDomainManageInfoData : NSObject

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * avatarUrl;
@property (nonatomic, strong) NSArray * banners;
@property (nonatomic, strong) NSArray * brightSpot;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSArray * covers;
@property (nonatomic, strong) NSString * createdAt;
@property (nonatomic, assign) NSInteger currentUserId;
@property (nonatomic, strong) NSString * des;
@property (nonatomic, strong) THNDomainManageInfoExtra * extra;
@property (nonatomic, assign) NSInteger isFavorite;
@property (nonatomic, assign) NSInteger isLove;
@property (nonatomic, strong) THNDomainManageInfoLocation * location;
@property (nonatomic, assign) NSInteger loveCount;
@property (nonatomic, strong) NSArray * nCovers;
@property (nonatomic, assign) NSInteger scoreAverage;
@property (nonatomic, strong) NSString * subTitle;
@property (nonatomic, strong) NSArray * tags;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) THNDomainManageInfoUser * user;
@property (nonatomic, assign) NSInteger viewCount;
@property (nonatomic, strong) NSString * viewUrl;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end