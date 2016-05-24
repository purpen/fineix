//
//	FindGoodsModelRow.m
// on 13/5/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "FindGoodsModelRow.h"

@interface FindGoodsModelRow ()
@end
@implementation FindGoodsModelRow




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"banners_url"] isKindOfClass:[NSNull class]]){
		self.bannersUrl = dictionary[@"banners_url"];
	}	
	if(![dictionary[@"cover_url"] isKindOfClass:[NSNull class]]){
		self.coverUrl = dictionary[@"cover_url"];
	}	
	if(![dictionary[@"link"] isKindOfClass:[NSNull class]]){
		self.link = dictionary[@"link"];
	}	
	if(![dictionary[@"market_price"] isKindOfClass:[NSNull class]]){
		self.marketPrice = dictionary[@"market_price"];
	}	
	if(![dictionary[@"oid"] isKindOfClass:[NSNull class]]){
		self.oid = [dictionary[@"oid"] integerValue];
	}

	if(![dictionary[@"sale_price"] isKindOfClass:[NSNull class]]){
		self.salePrice = dictionary[@"sale_price"];
	}	
	if(![dictionary[@"title"] isKindOfClass:[NSNull class]]){
		self.title = dictionary[@"title"];
	}	
	return self;
}
@end