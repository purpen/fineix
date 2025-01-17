//
//	SceneInfoData.h
// on 25/4/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "SceneInfoLocation.h"
#import "SceneInfoProduct.h"
#import "SceneInfoUserInfo.h"

@interface SceneInfoData : NSObject

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, strong) NSString * coverUrl;
@property (nonatomic, assign) NSInteger createdOn;
@property (nonatomic, assign) NSInteger currentUserId;
@property (nonatomic, strong) NSString * createdAt;
@property (nonatomic, strong) NSString * des;
@property (nonatomic, assign) NSInteger fine;
@property (nonatomic, assign) NSInteger isCheck;
@property (nonatomic, assign) NSInteger isLove;
@property (nonatomic, strong) SceneInfoLocation * location;
@property (nonatomic, assign) NSInteger loveCount;
@property (nonatomic, strong) NSArray * product;
@property (nonatomic, assign) NSInteger sceneId;
@property (nonatomic, strong) NSString * sceneTitle;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSArray * tagTitles;
@property (nonatomic, strong) NSArray * tags;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger trueViewCount;
@property (nonatomic, assign) NSInteger updatedOn;
@property (nonatomic, assign) NSInteger usedCount;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) SceneInfoUserInfo * userInfo;
@property (nonatomic, assign) NSInteger viewCount;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end