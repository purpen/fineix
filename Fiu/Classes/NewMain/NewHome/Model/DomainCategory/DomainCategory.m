//
//	DomainCategory.m
// on 20/2/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "DomainCategory.h"

NSString *const kDomainCategoryCurrentUserId = @"current_user_id";
NSString *const kDomainCategoryData = @"data";
NSString *const kDomainCategoryIsError = @"is_error";
NSString *const kDomainCategoryMessage = @"message";
NSString *const kDomainCategoryStatus = @"status";
NSString *const kDomainCategorySuccess = @"success";

@interface DomainCategory ()
@end
@implementation DomainCategory




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kDomainCategoryCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kDomainCategoryCurrentUserId] integerValue];
	}

	if(![dictionary[kDomainCategoryData] isKindOfClass:[NSNull class]]){
		self.data = [[DomainCategoryData alloc] initWithDictionary:dictionary[kDomainCategoryData]];
	}

	if(![dictionary[kDomainCategoryIsError] isKindOfClass:[NSNull class]]){
		self.isError = [dictionary[kDomainCategoryIsError] boolValue];
	}

	if(![dictionary[kDomainCategoryMessage] isKindOfClass:[NSNull class]]){
		self.message = dictionary[kDomainCategoryMessage];
	}	
	if(![dictionary[kDomainCategoryStatus] isKindOfClass:[NSNull class]]){
		self.status = dictionary[kDomainCategoryStatus];
	}	
	if(![dictionary[kDomainCategorySuccess] isKindOfClass:[NSNull class]]){
		self.success = [dictionary[kDomainCategorySuccess] boolValue];
	}

	return self;
}
@end
