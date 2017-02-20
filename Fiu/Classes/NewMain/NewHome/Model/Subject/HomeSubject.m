//
//	HomeSubject.m
// on 20/2/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "HomeSubject.h"

NSString *const kHomeSubjectCurrentUserId = @"current_user_id";
NSString *const kHomeSubjectData = @"data";
NSString *const kHomeSubjectIsError = @"is_error";
NSString *const kHomeSubjectMessage = @"message";
NSString *const kHomeSubjectStatus = @"status";
NSString *const kHomeSubjectSuccess = @"success";

@interface HomeSubject ()
@end
@implementation HomeSubject




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kHomeSubjectCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kHomeSubjectCurrentUserId] integerValue];
	}

	if(![dictionary[kHomeSubjectData] isKindOfClass:[NSNull class]]){
		self.data = [[HomeSubjectData alloc] initWithDictionary:dictionary[kHomeSubjectData]];
	}

	if(![dictionary[kHomeSubjectIsError] isKindOfClass:[NSNull class]]){
		self.isError = [dictionary[kHomeSubjectIsError] boolValue];
	}

	if(![dictionary[kHomeSubjectMessage] isKindOfClass:[NSNull class]]){
		self.message = dictionary[kHomeSubjectMessage];
	}	
	if(![dictionary[kHomeSubjectStatus] isKindOfClass:[NSNull class]]){
		self.status = dictionary[kHomeSubjectStatus];
	}	
	if(![dictionary[kHomeSubjectSuccess] isKindOfClass:[NSNull class]]){
		self.success = [dictionary[kHomeSubjectSuccess] boolValue];
	}

	return self;
}
@end