//
//	JDGoodsListproductbaseResult.m
// on 10/5/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "JDGoodsListproductbaseResult.h"

@interface JDGoodsListproductbaseResult ()
@end
@implementation JDGoodsListproductbaseResult




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"allnum"] isKindOfClass:[NSNull class]]){
		self.allnum = dictionary[@"allnum"];
	}	
	if(![dictionary[@"barCode"] isKindOfClass:[NSNull class]]){
		self.barCode = dictionary[@"barCode"];
	}	
	if(![dictionary[@"brandId"] isKindOfClass:[NSNull class]]){
		self.brandId = dictionary[@"brandId"];
	}	
	if(![dictionary[@"category"] isKindOfClass:[NSNull class]]){
		self.category = dictionary[@"category"];
	}	
	if(![dictionary[@"cbrand"] isKindOfClass:[NSNull class]]){
		self.cbrand = dictionary[@"cbrand"];
	}	
	if(![dictionary[@"cid2"] isKindOfClass:[NSNull class]]){
		self.cid2 = dictionary[@"cid2"];
	}	
	if(![dictionary[@"color"] isKindOfClass:[NSNull class]]){
		self.color = dictionary[@"color"];
	}	
	if(![dictionary[@"colorSequence"] isKindOfClass:[NSNull class]]){
		self.colorSequence = dictionary[@"colorSequence"];
	}	
	if(![dictionary[@"erpPid"] isKindOfClass:[NSNull class]]){
		self.erpPid = dictionary[@"erpPid"];
	}	
	if(![dictionary[@"height"] isKindOfClass:[NSNull class]]){
		self.height = dictionary[@"height"];
	}	
	if(![dictionary[@"imagePath"] isKindOfClass:[NSNull class]]){
		self.imagePath = dictionary[@"imagePath"];
	}	
	if(![dictionary[@"isDelete"] isKindOfClass:[NSNull class]]){
		self.isDelete = dictionary[@"isDelete"];
	}	
	if(![dictionary[@"issn"] isKindOfClass:[NSNull class]]){
		self.issn = dictionary[@"issn"];
	}	
	if(![dictionary[@"length"] isKindOfClass:[NSNull class]]){
		self.length = dictionary[@"length"];
	}	
	if(![dictionary[@"market_price"] isKindOfClass:[NSNull class]]){
		self.marketPrice = dictionary[@"market_price"];
	}	
	if(![dictionary[@"maxPurchQty"] isKindOfClass:[NSNull class]]){
		self.maxPurchQty = dictionary[@"maxPurchQty"];
	}	
	if(![dictionary[@"name"] isKindOfClass:[NSNull class]]){
		self.name = dictionary[@"name"];
	}	
	if(![dictionary[@"packSpecification"] isKindOfClass:[NSNull class]]){
		self.packSpecification = dictionary[@"packSpecification"];
	}	
	if(![dictionary[@"pname"] isKindOfClass:[NSNull class]]){
		self.pname = dictionary[@"pname"];
	}	
	if(![dictionary[@"safeDays"] isKindOfClass:[NSNull class]]){
		self.safeDays = dictionary[@"safeDays"];
	}	
	if(![dictionary[@"saleDate"] isKindOfClass:[NSNull class]]){
		self.saleDate = dictionary[@"saleDate"];
	}	
	if(![dictionary[@"sale_price"] isKindOfClass:[NSNull class]]){
		self.salePrice = dictionary[@"sale_price"];
	}	
	if(![dictionary[@"shopCategorys"] isKindOfClass:[NSNull class]]){
		self.shopCategorys = dictionary[@"shopCategorys"];
	}	
	if(![dictionary[@"shopName"] isKindOfClass:[NSNull class]]){
		self.shopName = dictionary[@"shopName"];
	}	
	if(![dictionary[@"sizeSequence"] isKindOfClass:[NSNull class]]){
		self.sizeSequence = dictionary[@"sizeSequence"];
	}	
	if(![dictionary[@"skuId"] isKindOfClass:[NSNull class]]){
		self.skuId = [dictionary[@"skuId"] integerValue];
	}

	if(![dictionary[@"skuMark"] isKindOfClass:[NSNull class]]){
		self.skuMark = dictionary[@"skuMark"];
	}	
	if(![dictionary[@"state"] isKindOfClass:[NSNull class]]){
		self.state = dictionary[@"state"];
	}	
	if(![dictionary[@"url"] isKindOfClass:[NSNull class]]){
		self.url = dictionary[@"url"];
	}	
	if(![dictionary[@"valuePayFirst"] isKindOfClass:[NSNull class]]){
		self.valuePayFirst = dictionary[@"valuePayFirst"];
	}	
	if(![dictionary[@"valueWeight"] isKindOfClass:[NSNull class]]){
		self.valueWeight = dictionary[@"valueWeight"];
	}	
	if(![dictionary[@"venderType"] isKindOfClass:[NSNull class]]){
		self.venderType = dictionary[@"venderType"];
	}	
	if(![dictionary[@"weight"] isKindOfClass:[NSNull class]]){
		self.weight = dictionary[@"weight"];
	}	
	if(![dictionary[@"width"] isKindOfClass:[NSNull class]]){
		self.width = dictionary[@"width"];
	}	
	return self;
}
@end