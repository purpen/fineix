//
//	THNSettlementInfoRow.m
// on 18/1/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNSettlementInfoRow.h"

NSString *const kTHNSettlementInfoRowIdField = @"_id";
NSString *const kTHNSettlementInfoRowAllianceId = @"alliance_id";
NSString *const kTHNSettlementInfoRowAmount = @"amount";
NSString *const kTHNSettlementInfoRowBalance = @"balance";
NSString *const kTHNSettlementInfoRowBalanceId = @"balance_id";
NSString *const kTHNSettlementInfoRowBalanceRecordId = @"balance_record_id";
NSString *const kTHNSettlementInfoRowCreatedAt = @"created_at";
NSString *const kTHNSettlementInfoRowCreatedOn = @"created_on";
NSString *const kTHNSettlementInfoRowStatus = @"status";
NSString *const kTHNSettlementInfoRowUpdatedOn = @"updated_on";
NSString *const kTHNSettlementInfoRowUserId = @"user_id";

@interface THNSettlementInfoRow ()
@end
@implementation THNSettlementInfoRow




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNSettlementInfoRowIdField] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[kTHNSettlementInfoRowIdField];
	}	
	if(![dictionary[kTHNSettlementInfoRowAllianceId] isKindOfClass:[NSNull class]]){
		self.allianceId = dictionary[kTHNSettlementInfoRowAllianceId];
	}	
	if(![dictionary[kTHNSettlementInfoRowAmount] isKindOfClass:[NSNull class]]){
		self.amount = [dictionary[kTHNSettlementInfoRowAmount] floatValue];
	}

	if(![dictionary[kTHNSettlementInfoRowBalance] isKindOfClass:[NSNull class]]){
		self.balance = [[THNSettlementInfoBalance alloc] initWithDictionary:dictionary[kTHNSettlementInfoRowBalance]];
	}

	if(![dictionary[kTHNSettlementInfoRowBalanceId] isKindOfClass:[NSNull class]]){
		self.balanceId = dictionary[kTHNSettlementInfoRowBalanceId];
	}	
	if(![dictionary[kTHNSettlementInfoRowBalanceRecordId] isKindOfClass:[NSNull class]]){
		self.balanceRecordId = dictionary[kTHNSettlementInfoRowBalanceRecordId];
	}	
	if(![dictionary[kTHNSettlementInfoRowCreatedAt] isKindOfClass:[NSNull class]]){
		self.createdAt = dictionary[kTHNSettlementInfoRowCreatedAt];
	}	
	if(![dictionary[kTHNSettlementInfoRowCreatedOn] isKindOfClass:[NSNull class]]){
		self.createdOn = [dictionary[kTHNSettlementInfoRowCreatedOn] integerValue];
	}

	if(![dictionary[kTHNSettlementInfoRowStatus] isKindOfClass:[NSNull class]]){
		self.status = [dictionary[kTHNSettlementInfoRowStatus] integerValue];
	}

	if(![dictionary[kTHNSettlementInfoRowUpdatedOn] isKindOfClass:[NSNull class]]){
		self.updatedOn = [dictionary[kTHNSettlementInfoRowUpdatedOn] integerValue];
	}

	if(![dictionary[kTHNSettlementInfoRowUserId] isKindOfClass:[NSNull class]]){
		self.userId = [dictionary[kTHNSettlementInfoRowUserId] integerValue];
	}

	return self;
}
@end