//
//	GoodsInfoData.h
// on 3/5/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "GoodsInfoBrand.h"

@interface GoodsInfoData : NSObject

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger attrbute;
@property (nonatomic, strong) NSArray * bannerAsset;
@property (nonatomic, strong) NSArray * thnAsset;
@property (nonatomic, strong) GoodsInfoBrand * brand;
@property (nonatomic, strong) NSArray * skus;
@property (nonatomic, strong) NSString * brandId;
@property (nonatomic, assign) NSInteger inventory;
@property (nonatomic, assign) NSInteger buyCount;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, strong) NSArray * categoryTags;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, strong) NSString * coverId;
@property (nonatomic, strong) NSString * coverUrl;
@property (nonatomic, strong) NSString * createdAt;
@property (nonatomic, assign) NSInteger createdOn;
@property (nonatomic, assign) NSInteger currentUserId;
@property (nonatomic, assign) NSInteger deleted;
@property (nonatomic, strong) NSString * descriptionField;
@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, assign) NSInteger fid;
@property (nonatomic, assign) NSInteger fine;
@property (nonatomic, assign) NSInteger isFavorite;
@property (nonatomic, assign) NSInteger isLove;
@property (nonatomic, assign) NSInteger kind;
@property (nonatomic, strong) NSString * link;
@property (nonatomic, assign) NSInteger loveCount;
@property (nonatomic, assign) CGFloat marketPrice;
@property (nonatomic, strong) NSString * oid;
@property (nonatomic, strong) NSArray * pngAsset;
@property (nonatomic, assign) NSInteger published;
@property (nonatomic, assign) CGFloat salePrice;
@property (nonatomic, strong) NSString * shortTitle;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, assign) NSInteger stick;
@property (nonatomic, strong) NSString * summary;
@property (nonatomic, strong) NSArray * tags;
@property (nonatomic, strong) NSString * tagsS;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger updatedOn;
@property (nonatomic, assign) NSInteger viewCount;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end