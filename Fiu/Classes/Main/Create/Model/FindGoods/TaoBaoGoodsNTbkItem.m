//
//	TaoBaoGoodsNTbkItem.m
// on 4/5/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "TaoBaoGoodsNTbkItem.h"

@interface TaoBaoGoodsNTbkItem ()
@end
@implementation TaoBaoGoodsNTbkItem




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"item_url"] isKindOfClass:[NSNull class]]){
		self.itemUrl = dictionary[@"item_url"];
	}	
	if(![dictionary[@"num_iid"] isKindOfClass:[NSNull class]]){
		self.numIid = [dictionary[@"num_iid"] integerValue];
	}

	if(![dictionary[@"pict_url"] isKindOfClass:[NSNull class]]){
		self.pictUrl = dictionary[@"pict_url"];
	}	
	if(![dictionary[@"provcity"] isKindOfClass:[NSNull class]]){
		self.provcity = dictionary[@"provcity"];
	}	
	if(![dictionary[@"reserve_price"] isKindOfClass:[NSNull class]]){
		self.reservePrice = dictionary[@"reserve_price"];
	}	
	if(![dictionary[@"small_images"] isKindOfClass:[NSNull class]]){
		self.smallImages = [[TaoBaoGoodsSmallImage alloc] initWithDictionary:dictionary[@"small_images"]];
	}

	if(![dictionary[@"title"] isKindOfClass:[NSNull class]]){
		self.title = dictionary[@"title"];
	}	
	if(![dictionary[@"user_type"] isKindOfClass:[NSNull class]]){
		self.userType = [dictionary[@"user_type"] integerValue];
	}

	if(![dictionary[@"zk_final_price"] isKindOfClass:[NSNull class]]){
		self.zkFinalPrice = dictionary[@"zk_final_price"];
	}	
	return self;
}
@end