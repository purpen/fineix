//
//	THNMallGoodsModel.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNMallGoodsModel.h"

NSString *const kTHNMallGoodsModelCurrentUserId = @"current_user_id";
NSString *const kTHNMallGoodsModelData = @"data";
NSString *const kTHNMallGoodsModelIsError = @"is_error";
NSString *const kTHNMallGoodsModelMessage = @"message";
NSString *const kTHNMallGoodsModelStatus = @"status";
NSString *const kTHNMallGoodsModelSuccess = @"success";

@interface THNMallGoodsModel ()
@end
@implementation THNMallGoodsModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNMallGoodsModelCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kTHNMallGoodsModelCurrentUserId] integerValue];
	}

	if(![dictionary[kTHNMallGoodsModelData] isKindOfClass:[NSNull class]]){
		self.data = [[THNMallGoodsModelData alloc] initWithDictionary:dictionary[kTHNMallGoodsModelData]];
	}

	if(![dictionary[kTHNMallGoodsModelIsError] isKindOfClass:[NSNull class]]){
		self.isError = [dictionary[kTHNMallGoodsModelIsError] boolValue];
	}

	if(![dictionary[kTHNMallGoodsModelMessage] isKindOfClass:[NSNull class]]){
		self.message = dictionary[kTHNMallGoodsModelMessage];
	}	
	if(![dictionary[kTHNMallGoodsModelStatus] isKindOfClass:[NSNull class]]){
		self.status = dictionary[kTHNMallGoodsModelStatus];
	}	
	if(![dictionary[kTHNMallGoodsModelSuccess] isKindOfClass:[NSNull class]]){
		self.success = [dictionary[kTHNMallGoodsModelSuccess] boolValue];
	}

	return self;
}
@end