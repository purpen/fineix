//
//	JDGoods.m
// on 10/5/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "JDGoods.h"

@interface JDGoods ()
@end
@implementation JDGoods




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"current_user_id"] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[@"current_user_id"] integerValue];
	}

	if(![dictionary[@"data"] isKindOfClass:[NSNull class]]){
		self.data = [[JDGoodsData alloc] initWithDictionary:dictionary[@"data"]];
	}

	if(![dictionary[@"is_error"] isKindOfClass:[NSNull class]]){
		self.isError = [dictionary[@"is_error"] boolValue];
	}

	if(![dictionary[@"message"] isKindOfClass:[NSNull class]]){
		self.message = dictionary[@"message"];
	}	
	if(![dictionary[@"status"] isKindOfClass:[NSNull class]]){
		self.status = dictionary[@"status"];
	}	
	if(![dictionary[@"success"] isKindOfClass:[NSNull class]]){
		self.success = [dictionary[@"success"] boolValue];
	}

	return self;
}
@end