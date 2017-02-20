//
//	HomeGoods.m
// on 20/2/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "HomeGoods.h"

NSString *const kHomeGoodsCurrentUserId = @"current_user_id";
NSString *const kHomeGoodsData = @"data";
NSString *const kHomeGoodsIsError = @"is_error";
NSString *const kHomeGoodsMessage = @"message";
NSString *const kHomeGoodsStatus = @"status";
NSString *const kHomeGoodsSuccess = @"success";

@interface HomeGoods ()
@end
@implementation HomeGoods




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kHomeGoodsCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kHomeGoodsCurrentUserId] integerValue];
	}

	if(![dictionary[kHomeGoodsData] isKindOfClass:[NSNull class]]){
		self.data = [[HomeGoodsData alloc] initWithDictionary:dictionary[kHomeGoodsData]];
	}

	if(![dictionary[kHomeGoodsIsError] isKindOfClass:[NSNull class]]){
		self.isError = [dictionary[kHomeGoodsIsError] boolValue];
	}

	if(![dictionary[kHomeGoodsMessage] isKindOfClass:[NSNull class]]){
		self.message = dictionary[kHomeGoodsMessage];
	}	
	if(![dictionary[kHomeGoodsStatus] isKindOfClass:[NSNull class]]){
		self.status = dictionary[kHomeGoodsStatus];
	}	
	if(![dictionary[kHomeGoodsSuccess] isKindOfClass:[NSNull class]]){
		self.success = [dictionary[kHomeGoodsSuccess] boolValue];
	}

	return self;
}
@end
