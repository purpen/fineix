//
//	THNSettlementInfo.m
// on 18/1/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNSettlementInfo.h"

NSString *const kTHNSettlementInfoCurrentUserId = @"current_user_id";
NSString *const kTHNSettlementInfoData = @"data";
NSString *const kTHNSettlementInfoIsError = @"is_error";
NSString *const kTHNSettlementInfoMessage = @"message";
NSString *const kTHNSettlementInfoStatus = @"status";
NSString *const kTHNSettlementInfoSuccess = @"success";

@interface THNSettlementInfo ()
@end
@implementation THNSettlementInfo




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNSettlementInfoCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kTHNSettlementInfoCurrentUserId] integerValue];
	}

	if(![dictionary[kTHNSettlementInfoData] isKindOfClass:[NSNull class]]){
		self.data = [[THNSettlementInfoData alloc] initWithDictionary:dictionary[kTHNSettlementInfoData]];
	}

	if(![dictionary[kTHNSettlementInfoIsError] isKindOfClass:[NSNull class]]){
		self.isError = [dictionary[kTHNSettlementInfoIsError] boolValue];
	}

	if(![dictionary[kTHNSettlementInfoMessage] isKindOfClass:[NSNull class]]){
		self.message = dictionary[kTHNSettlementInfoMessage];
	}	
	if(![dictionary[kTHNSettlementInfoStatus] isKindOfClass:[NSNull class]]){
		self.status = dictionary[kTHNSettlementInfoStatus];
	}	
	if(![dictionary[kTHNSettlementInfoSuccess] isKindOfClass:[NSNull class]]){
		self.success = [dictionary[kTHNSettlementInfoSuccess] boolValue];
	}

	return self;
}
@end