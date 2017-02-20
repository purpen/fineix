//
//	NiceDomain.m
// on 20/2/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "NiceDomain.h"

NSString *const kNiceDomainCurrentUserId = @"current_user_id";
NSString *const kNiceDomainData = @"data";
NSString *const kNiceDomainIsError = @"is_error";
NSString *const kNiceDomainMessage = @"message";
NSString *const kNiceDomainStatus = @"status";
NSString *const kNiceDomainSuccess = @"success";

@interface NiceDomain ()
@end
@implementation NiceDomain




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kNiceDomainCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kNiceDomainCurrentUserId] integerValue];
	}

	if(![dictionary[kNiceDomainData] isKindOfClass:[NSNull class]]){
		self.data = [[NiceDomainData alloc] initWithDictionary:dictionary[kNiceDomainData]];
	}

	if(![dictionary[kNiceDomainIsError] isKindOfClass:[NSNull class]]){
		self.isError = [dictionary[kNiceDomainIsError] boolValue];
	}

	if(![dictionary[kNiceDomainMessage] isKindOfClass:[NSNull class]]){
		self.message = dictionary[kNiceDomainMessage];
	}	
	if(![dictionary[kNiceDomainStatus] isKindOfClass:[NSNull class]]){
		self.status = dictionary[kNiceDomainStatus];
	}	
	if(![dictionary[kNiceDomainSuccess] isKindOfClass:[NSNull class]]){
		self.success = [dictionary[kNiceDomainSuccess] boolValue];
	}

	return self;
}
@end
