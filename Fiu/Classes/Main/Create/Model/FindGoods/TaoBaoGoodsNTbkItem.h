//
//	TaoBaoGoodsNTbkItem.h
// on 4/5/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "TaoBaoGoodsSmallImage.h"

@interface TaoBaoGoodsNTbkItem : NSObject

@property (nonatomic, strong) NSString * itemUrl;
@property (nonatomic, assign) NSInteger numIid;
@property (nonatomic, strong) NSString * pictUrl;
@property (nonatomic, strong) NSString * provcity;
@property (nonatomic, strong) NSString * reservePrice;
@property (nonatomic, strong) TaoBaoGoodsSmallImage * smallImages;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger userType;
@property (nonatomic, strong) NSString * zkFinalPrice;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end