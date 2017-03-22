#import <UIKit/UIKit.h>
#import "FBGoodsInfoModelBrand.h"
#import "FBGoodsInfoModelRelationProduct.h"
#import "FBGoodsInfoModelExtra.h"
#import "FBGoodsInfoModelSku.h"

@interface FBGoodsInfoModelData : NSObject

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger orderReduce;
@property (nonatomic, strong) NSString * advantage;
@property (nonatomic, assign) NSInteger appAppointCount;
@property (nonatomic, assign) NSInteger appSnatched;
@property (nonatomic, assign) NSInteger appSnatchedCount;
@property (nonatomic, assign) BOOL appSnatchedEndTime;
@property (nonatomic, assign) NSInteger appSnatchedLimitCount;
@property (nonatomic, assign) NSInteger appSnatchedPrice;
@property (nonatomic, assign) NSInteger appSnatchedRestCount;
@property (nonatomic, assign) NSInteger appSnatchedStat;
@property (nonatomic, assign) BOOL appSnatchedTime;
@property (nonatomic, assign) NSInteger appSnatchedTimeLag;
@property (nonatomic, assign) NSInteger appSnatchedTotalCount;
@property (nonatomic, strong) NSArray * asset;
@property (nonatomic, strong) FBGoodsInfoModelBrand * brand;
@property (nonatomic, strong) FBGoodsInfoModelExtra * extra;
@property (nonatomic, strong) NSString * brandId;
@property (nonatomic, strong) NSObject * canSaled;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, strong) NSArray * categoryTags;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, assign) NSInteger commentStar;
@property (nonatomic, strong) NSString * contentViewUrl;
@property (nonatomic, strong) NSString * coverId;
@property (nonatomic, strong) NSString * coverUrl;
@property (nonatomic, assign) NSInteger currentUserId;
@property (nonatomic, strong) NSString * extraInfo;
@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, assign) NSInteger inventory;
@property (nonatomic, assign) NSInteger isAppSnatched;
@property (nonatomic, assign) NSInteger isAppSnatchedAlert;
@property (nonatomic, assign) NSInteger isFavorite;
@property (nonatomic, assign) NSInteger isLove;
@property (nonatomic, assign) NSInteger isTry;
@property (nonatomic, assign) NSInteger loveCount;
@property (nonatomic, assign) NSInteger marketPrice;
@property (nonatomic, strong) NSArray * pngAsset;
@property (nonatomic, strong) NSArray * relationProducts;
@property (nonatomic, assign) NSInteger salePrice;
@property (nonatomic, strong) NSString * shareDesc;
@property (nonatomic, strong) NSString * shareViewUrl;
@property (nonatomic, strong) NSString * shortTitle;
@property (nonatomic, strong) NSArray * skus;
@property (nonatomic, assign) NSInteger skusCount;
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
