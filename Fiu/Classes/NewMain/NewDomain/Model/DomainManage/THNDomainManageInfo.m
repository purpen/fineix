//
//	THNDomainManageInfo.m
// on 10/3/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNDomainManageInfo.h"

NSString *const kTHNDomainManageInfoCurrentUserId = @"current_user_id";
NSString *const kTHNDomainManageInfoData = @"data";
NSString *const kTHNDomainManageInfoIsError = @"is_error";
NSString *const kTHNDomainManageInfoMessage = @"message";
NSString *const kTHNDomainManageInfoStatus = @"status";
NSString *const kTHNDomainManageInfoSuccess = @"success";

@interface THNDomainManageInfo ()
@end
@implementation THNDomainManageInfo




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNDomainManageInfoCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kTHNDomainManageInfoCurrentUserId] integerValue];
	}

	if(![dictionary[kTHNDomainManageInfoData] isKindOfClass:[NSNull class]]){
		self.data = [[THNDomainManageInfoData alloc] initWithDictionary:dictionary[kTHNDomainManageInfoData]];
	}

	if(![dictionary[kTHNDomainManageInfoIsError] isKindOfClass:[NSNull class]]){
		self.isError = [dictionary[kTHNDomainManageInfoIsError] boolValue];
	}

	if(![dictionary[kTHNDomainManageInfoMessage] isKindOfClass:[NSNull class]]){
		self.message = dictionary[kTHNDomainManageInfoMessage];
	}	
	if(![dictionary[kTHNDomainManageInfoStatus] isKindOfClass:[NSNull class]]){
		self.status = dictionary[kTHNDomainManageInfoStatus];
	}	
	if(![dictionary[kTHNDomainManageInfoSuccess] isKindOfClass:[NSNull class]]){
		self.success = [dictionary[kTHNDomainManageInfoSuccess] boolValue];
	}

	return self;
}
@end