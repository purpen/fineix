//
//	THNBalanceRow.m
// on 18/1/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNBalanceRow.h"

NSString *const kTHNBalanceRowIdField = @"_id";
NSString *const kTHNBalanceRowAllianceId = @"alliance_id";
NSString *const kTHNBalanceRowAmount = @"amount";
NSString *const kTHNBalanceRowBalanceCount = @"balance_count";
NSString *const kTHNBalanceRowCreatedAt = @"created_at";
NSString *const kTHNBalanceRowCreatedOn = @"created_on";
NSString *const kTHNBalanceRowStatus = @"status";
NSString *const kTHNBalanceRowUpdatedOn = @"updated_on";
NSString *const kTHNBalanceRowUserId = @"user_id";

@interface THNBalanceRow ()
@end
@implementation THNBalanceRow




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNBalanceRowIdField] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[kTHNBalanceRowIdField];
	}	
	if(![dictionary[kTHNBalanceRowAllianceId] isKindOfClass:[NSNull class]]){
		self.allianceId = dictionary[kTHNBalanceRowAllianceId];
	}	
	if(![dictionary[kTHNBalanceRowAmount] isKindOfClass:[NSNull class]]){
		self.amount = [dictionary[kTHNBalanceRowAmount] floatValue];
	}

	if(![dictionary[kTHNBalanceRowBalanceCount] isKindOfClass:[NSNull class]]){
		self.balanceCount = [dictionary[kTHNBalanceRowBalanceCount] integerValue];
	}

	if(![dictionary[kTHNBalanceRowCreatedAt] isKindOfClass:[NSNull class]]){
		self.createdAt = dictionary[kTHNBalanceRowCreatedAt];
	}	
	if(![dictionary[kTHNBalanceRowCreatedOn] isKindOfClass:[NSNull class]]){
		self.createdOn = [dictionary[kTHNBalanceRowCreatedOn] integerValue];
	}

	if(![dictionary[kTHNBalanceRowStatus] isKindOfClass:[NSNull class]]){
		self.status = [dictionary[kTHNBalanceRowStatus] integerValue];
	}

	if(![dictionary[kTHNBalanceRowUpdatedOn] isKindOfClass:[NSNull class]]){
		self.updatedOn = [dictionary[kTHNBalanceRowUpdatedOn] integerValue];
	}

	if(![dictionary[kTHNBalanceRowUserId] isKindOfClass:[NSNull class]]){
		self.userId = [dictionary[kTHNBalanceRowUserId] integerValue];
	}

	return self;
}
@end