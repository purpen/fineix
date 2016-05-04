//
//	GoodsRow.h
// on 28/4/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface GoodsRow : NSObject

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger attrbute;
@property (nonatomic, strong) NSArray * bannerAsset;
@property (nonatomic, strong) NSArray * banner;
@property (nonatomic, assign) NSInteger bannerId;
@property (nonatomic, strong) NSString * brandId;
@property (nonatomic, assign) NSInteger buyCount;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, strong) NSArray * categoryTags;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, strong) NSString * coverId;
@property (nonatomic, strong) NSString * coverUrl;
@property (nonatomic, strong) NSString * createdAt;
@property (nonatomic, assign) NSInteger createdOn;
@property (nonatomic, assign) NSInteger deleted;
@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, assign) NSInteger fid;
@property (nonatomic, assign) NSInteger fine;
@property (nonatomic, assign) NSInteger kind;
@property (nonatomic, strong) NSString * link;
@property (nonatomic, assign) NSInteger loveCount;
@property (nonatomic, assign) CGFloat  marketPrice;
@property (nonatomic, strong) NSString * oid;
@property (nonatomic, assign) NSInteger published;
@property (nonatomic, assign) CGFloat  salePrice;
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