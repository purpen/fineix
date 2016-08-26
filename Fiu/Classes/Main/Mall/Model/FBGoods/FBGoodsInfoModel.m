//
//	FBGoodsInfoModel.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "FBGoodsInfoModel.h"

NSString *const kFBGoodsInfoModelCurrentUserId = @"current_user_id";
NSString *const kFBGoodsInfoModelData = @"data";
NSString *const kFBGoodsInfoModelIsError = @"is_error";
NSString *const kFBGoodsInfoModelMessage = @"message";
NSString *const kFBGoodsInfoModelStatus = @"status";
NSString *const kFBGoodsInfoModelSuccess = @"success";

@interface FBGoodsInfoModel ()
@end
@implementation FBGoodsInfoModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kFBGoodsInfoModelCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kFBGoodsInfoModelCurrentUserId] integerValue];
	}

	if(![dictionary[kFBGoodsInfoModelData] isKindOfClass:[NSNull class]]){
		self.data = [[FBGoodsInfoModelData alloc] initWithDictionary:dictionary[kFBGoodsInfoModelData]];
	}

	if(![dictionary[kFBGoodsInfoModelIsError] isKindOfClass:[NSNull class]]){
		self.isError = [dictionary[kFBGoodsInfoModelIsError] boolValue];
	}

	if(![dictionary[kFBGoodsInfoModelMessage] isKindOfClass:[NSNull class]]){
		self.message = dictionary[kFBGoodsInfoModelMessage];
	}	
	if(![dictionary[kFBGoodsInfoModelStatus] isKindOfClass:[NSNull class]]){
		self.status = dictionary[kFBGoodsInfoModelStatus];
	}	
	if(![dictionary[kFBGoodsInfoModelSuccess] isKindOfClass:[NSNull class]]){
		self.success = [dictionary[kFBGoodsInfoModelSuccess] boolValue];
	}

	return self;
}
@end