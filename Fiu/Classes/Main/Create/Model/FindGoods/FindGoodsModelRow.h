//
//	FindGoodsModelRow.h
// on 13/5/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface FindGoodsModelRow : NSObject

@property (nonatomic, strong) NSArray * bannersUrl;
@property (nonatomic, strong) NSString * coverUrl;
@property (nonatomic, strong) NSString * link;
@property (nonatomic, strong) NSString * marketPrice;
@property (nonatomic, assign) NSInteger oid;
@property (nonatomic, strong) NSString * salePrice;
@property (nonatomic, strong) NSString * title;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end