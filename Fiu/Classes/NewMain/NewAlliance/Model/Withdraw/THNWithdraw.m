//
//	THNWithdraw.m
// on 18/1/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNWithdraw.h"

NSString *const kTHNWithdrawCurrentUserId = @"current_user_id";
NSString *const kTHNWithdrawData = @"data";
NSString *const kTHNWithdrawIsError = @"is_error";
NSString *const kTHNWithdrawMessage = @"message";
NSString *const kTHNWithdrawStatus = @"status";
NSString *const kTHNWithdrawSuccess = @"success";

@interface THNWithdraw ()
@end
@implementation THNWithdraw




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNWithdrawCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kTHNWithdrawCurrentUserId] integerValue];
	}

	if(![dictionary[kTHNWithdrawData] isKindOfClass:[NSNull class]]){
		self.data = [[THNWithdrawData alloc] initWithDictionary:dictionary[kTHNWithdrawData]];
	}

	if(![dictionary[kTHNWithdrawIsError] isKindOfClass:[NSNull class]]){
		self.isError = [dictionary[kTHNWithdrawIsError] boolValue];
	}

	if(![dictionary[kTHNWithdrawMessage] isKindOfClass:[NSNull class]]){
		self.message = dictionary[kTHNWithdrawMessage];
	}	
	if(![dictionary[kTHNWithdrawStatus] isKindOfClass:[NSNull class]]){
		self.status = dictionary[kTHNWithdrawStatus];
	}	
	if(![dictionary[kTHNWithdrawSuccess] isKindOfClass:[NSNull class]]){
		self.success = [dictionary[kTHNWithdrawSuccess] boolValue];
	}

	return self;
}
@end