//
//	GoodsInfoBrand.h
// on 3/5/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface GoodsInfoBrand : NSObject

@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * coverUrl;
@property (nonatomic, strong) NSString * des;
@property (nonatomic, strong) NSString * title;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end