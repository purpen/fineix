//
//	TaoBaoGoodsData.m
// on 4/5/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "TaoBaoGoodsData.h"

@interface TaoBaoGoodsData ()
@end
@implementation TaoBaoGoodsData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"current_user_id"] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[@"current_user_id"] integerValue];
	}

	if(![dictionary[@"request_id"] isKindOfClass:[NSNull class]]){
		self.requestId = dictionary[@"request_id"];
	}	
	if(![dictionary[@"results"] isKindOfClass:[NSNull class]]){
		self.results = [[TaoBaoGoodsResult alloc] initWithDictionary:dictionary[@"results"]];
	}

	return self;
}
@end