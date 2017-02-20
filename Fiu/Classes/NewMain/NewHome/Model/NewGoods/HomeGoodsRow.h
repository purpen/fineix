//
//	HomeGoodsRow.h
// on 20/2/2017
//	Copyright © 2017. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface HomeGoodsRow : NSObject

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * advantage;
@property (nonatomic, assign) NSInteger appAppointCount;
@property (nonatomic, assign) NSInteger appSnatched;
@property (nonatomic, assign) NSInteger appSnatchedCount;
@property (nonatomic, assign) BOOL appSnatchedEndTime;
@property (nonatomic, assign) NSInteger appSnatchedPrice;
@property (nonatomic, assign) BOOL appSnatchedTime;
@property (nonatomic, assign) NSInteger appSnatchedTotalCount;
@property (nonatomic, strong) NSString * brandId;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, strong) NSArray * categoryIds;
@property (nonatomic, strong) NSArray * categoryTags;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, assign) NSInteger commentStar;
@property (nonatomic, strong) NSString * contentViewUrl;
@property (nonatomic, strong) NSString * coverId;
@property (nonatomic, strong) NSString * coverUrl;
@property (nonatomic, assign) NSInteger createdOn;
@property (nonatomic, assign) NSInteger deleted;
@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, assign) NSInteger featured;
@property (nonatomic, assign) NSInteger inventory;
@property (nonatomic, assign) NSInteger isAppSnatched;
@property (nonatomic, assign) NSInteger loveCount;
@property (nonatomic, assign) NSInteger marketPrice;
@property (nonatomic, assign) NSInteger presaleFinishTime;
@property (nonatomic, assign) NSInteger presaleGoals;
@property (nonatomic, assign) NSInteger presaleMoney;
@property (nonatomic, assign) NSInteger presalePeople;
@property (nonatomic, assign) NSInteger presalePercent;
@property (nonatomic, assign) CGFloat salePrice;
@property (nonatomic, strong) NSString * shortTitle;
@property (nonatomic, assign) NSInteger snatched;
@property (nonatomic, assign) NSInteger snatchedCount;
@property (nonatomic, assign) BOOL snatchedEndTime;
@property (nonatomic, assign) CGFloat snatchedPrice;
@property (nonatomic, assign) NSInteger snatchedTime;
@property (nonatomic, assign) NSInteger stage;
@property (nonatomic, assign) NSInteger stick;
@property (nonatomic, assign) NSInteger succeed;
@property (nonatomic, strong) NSString * summary;
@property (nonatomic, strong) NSArray * tags;
@property (nonatomic, strong) NSString * tagsS;
@property (nonatomic, assign) NSInteger tipsLabel;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger topicCount;
@property (nonatomic, assign) NSInteger updatedOn;
@property (nonatomic, assign) NSInteger viewCount;
@property (nonatomic, assign) NSInteger voteFavorCount;
@property (nonatomic, assign) NSInteger voteOpposeCount;
@property (nonatomic, assign) NSInteger votedFinishTime;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
