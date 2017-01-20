//
//	THNWithdrawRow.m
// on 18/1/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNWithdrawRow.h"

NSString *const kTHNWithdrawRowIdField = @"_id";
NSString *const kTHNWithdrawRowAllianceId = @"alliance_id";
NSString *const kTHNWithdrawRowAmount = @"amount";
NSString *const kTHNWithdrawRowCreatedOn = @"created_on";
NSString *const kTHNWithdrawRowCreatedAt = @"created_at";
NSString *const kTHNWithdrawRowPresentOn = @"present_on";
NSString *const kTHNWithdrawRowStatus = @"status";
NSString *const kTHNWithdrawRowUpdatedOn = @"updated_on";
NSString *const kTHNWithdrawRowUserId = @"user_id";

@interface THNWithdrawRow ()
@end
@implementation THNWithdrawRow




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNWithdrawRowIdField] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[kTHNWithdrawRowIdField];
	}	
	if(![dictionary[kTHNWithdrawRowAllianceId] isKindOfClass:[NSNull class]]){
		self.allianceId = dictionary[kTHNWithdrawRowAllianceId];
	}	
	if(![dictionary[kTHNWithdrawRowAmount] isKindOfClass:[NSNull class]]){
		self.amount = [dictionary[kTHNWithdrawRowAmount] floatValue];
	}

	if(![dictionary[kTHNWithdrawRowCreatedOn] isKindOfClass:[NSNull class]]){
		self.createdOn = [dictionary[kTHNWithdrawRowCreatedOn] integerValue];
	}

	if(![dictionary[kTHNWithdrawRowPresentOn] isKindOfClass:[NSNull class]]){
		self.presentOn = [dictionary[kTHNWithdrawRowPresentOn] integerValue];
	}

	if(![dictionary[kTHNWithdrawRowStatus] isKindOfClass:[NSNull class]]){
		self.status = [dictionary[kTHNWithdrawRowStatus] integerValue];
	}

	if(![dictionary[kTHNWithdrawRowUpdatedOn] isKindOfClass:[NSNull class]]){
		self.updatedOn = [dictionary[kTHNWithdrawRowUpdatedOn] integerValue];
	}

	if(![dictionary[kTHNWithdrawRowUserId] isKindOfClass:[NSNull class]]){
		self.userId = [dictionary[kTHNWithdrawRowUserId] integerValue];
	}
    
    if(![dictionary[kTHNWithdrawRowCreatedAt] isKindOfClass:[NSNull class]]){
        self.createdAt = dictionary[kTHNWithdrawRowCreatedAt];
    }

	return self;
}
@end
