//
//	DominInfoData.h
//  on 17/2/2017
//	Copyright © 2017. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "DominInfoExtra.h"
#import "DominInfoLocation.h"
#import "DominInfoUser.h"

@interface DominInfoData : NSObject

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * avatarUrl;
@property (nonatomic, strong) NSArray * banners;
@property (nonatomic, strong) NSArray * brightSpot;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * createdAt;
@property (nonatomic, assign) NSInteger currentUserId;
@property (nonatomic, strong) NSString * des;
@property (nonatomic, strong) DominInfoExtra * extra;
@property (nonatomic, assign) NSInteger isLove;
@property (nonatomic, strong) DominInfoLocation * location;
@property (nonatomic, assign) NSInteger loveCount;
@property (nonatomic, strong) NSArray * products;
@property (nonatomic, assign) NSInteger scoreAverage;
@property (nonatomic, strong) NSArray * sights;
@property (nonatomic, strong) NSString * subTitle;
@property (nonatomic, strong) NSArray * tags;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) DominInfoUser * user;
@property (nonatomic, assign) NSInteger viewCount;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
