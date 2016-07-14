//
//	FBGoodsInfoModelRelationProduct.h
// on 14/7/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface FBGoodsInfoModelRelationProduct : NSObject

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * advantage;
@property (nonatomic, assign) NSInteger appAppointCount;
@property (nonatomic, assign) NSInteger appSnatched;
@property (nonatomic, assign) NSInteger appSnatchedCount;
@property (nonatomic, assign) BOOL appSnatchedEndTime;
@property (nonatomic, assign) NSInteger appSnatchedLimitCount;
@property (nonatomic, assign) NSInteger appSnatchedPrice;
@property (nonatomic, assign) BOOL appSnatchedTime;
@property (nonatomic, assign) NSInteger appSnatchedTotalCount;
@property (nonatomic, strong) NSString * brandId;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, strong) NSArray * categoryTags;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, assign) NSInteger commentStar;
@property (nonatomic, strong) NSString * coverId;
@property (nonatomic, strong) NSString * coverUrl;
@property (nonatomic, strong) NSObject * extraInfo;
@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, assign) NSInteger inventory;
@property (nonatomic, assign) NSInteger loveCount;
@property (nonatomic, assign) NSInteger marketPrice;
@property (nonatomic, assign) NSInteger salePrice;
@property (nonatomic, strong) NSString * shortTitle;
@property (nonatomic, assign) NSInteger snatched;
@property (nonatomic, assign) NSInteger snatchedCount;
@property (nonatomic, assign) BOOL snatchedEndTime;
@property (nonatomic, assign) NSInteger snatchedPrice;
@property (nonatomic, assign) BOOL snatchedTime;
@property (nonatomic, assign) NSInteger stage;
@property (nonatomic, assign) NSInteger stick;
@property (nonatomic, strong) NSString * summary;
@property (nonatomic, strong) NSArray * tags;
@property (nonatomic, strong) NSString * tagsS;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger viewCount;
@property (nonatomic, strong) NSString * wapViewUrl;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end