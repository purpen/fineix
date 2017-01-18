//
//	THNAllinaceData.m
// on 18/1/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNAllinaceData.h"

NSString *const kTHNAllinaceDataIdField = @"_id";
NSString *const kTHNAllinaceDataCode = @"code";
NSString *const kTHNAllinaceDataContact = @"contact";
NSString *const kTHNAllinaceDataCreatedOn = @"created_on";
NSString *const kTHNAllinaceDataCurrentUserId = @"current_user_id";
NSString *const kTHNAllinaceDataKind = @"kind";
NSString *const kTHNAllinaceDataName = @"name";
NSString *const kTHNAllinaceDataStatus = @"status";
NSString *const kTHNAllinaceDataSuccessCount = @"success_count";
NSString *const kTHNAllinaceDataSummary = @"summary";
NSString *const kTHNAllinaceDataTotalBalanceAmount = @"total_balance_amount";
NSString *const kTHNAllinaceDataTotalCashAmount = @"total_cash_amount";
NSString *const kTHNAllinaceDataTotalCount = @"total_count";
NSString *const kTHNAllinaceDataType = @"type";
NSString *const kTHNAllinaceDataUpdatedOn = @"updated_on";
NSString *const kTHNAllinaceDataWaitCashAmount = @"wait_cash_amount";
NSString *const kTHNAllinaceDataWhetherApplyCash = @"whether_apply_cash";
NSString *const kTHNAllinaceDataWhetherBalanceStat = @"whether_balance_stat";

@interface THNAllinaceData ()
@end
@implementation THNAllinaceData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNAllinaceDataIdField] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[kTHNAllinaceDataIdField];
	}	
	if(![dictionary[kTHNAllinaceDataCode] isKindOfClass:[NSNull class]]){
		self.code = dictionary[kTHNAllinaceDataCode];
	}	
	if(![dictionary[kTHNAllinaceDataContact] isKindOfClass:[NSNull class]]){
		self.contact = [[THNAllinaceContact alloc] initWithDictionary:dictionary[kTHNAllinaceDataContact]];
	}

	if(![dictionary[kTHNAllinaceDataCreatedOn] isKindOfClass:[NSNull class]]){
		self.createdOn = [dictionary[kTHNAllinaceDataCreatedOn] integerValue];
	}

	if(![dictionary[kTHNAllinaceDataCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kTHNAllinaceDataCurrentUserId] integerValue];
	}

	if(![dictionary[kTHNAllinaceDataKind] isKindOfClass:[NSNull class]]){
		self.kind = [dictionary[kTHNAllinaceDataKind] integerValue];
	}

	if(![dictionary[kTHNAllinaceDataName] isKindOfClass:[NSNull class]]){
		self.name = dictionary[kTHNAllinaceDataName];
	}	
	if(![dictionary[kTHNAllinaceDataStatus] isKindOfClass:[NSNull class]]){
		self.status = [dictionary[kTHNAllinaceDataStatus] integerValue];
	}

	if(![dictionary[kTHNAllinaceDataSuccessCount] isKindOfClass:[NSNull class]]){
		self.successCount = [dictionary[kTHNAllinaceDataSuccessCount] integerValue];
	}

	if(![dictionary[kTHNAllinaceDataSummary] isKindOfClass:[NSNull class]]){
		self.summary = dictionary[kTHNAllinaceDataSummary];
	}	
	if(![dictionary[kTHNAllinaceDataTotalBalanceAmount] isKindOfClass:[NSNull class]]){
		self.totalBalanceAmount = [dictionary[kTHNAllinaceDataTotalBalanceAmount] floatValue];
	}

	if(![dictionary[kTHNAllinaceDataTotalCashAmount] isKindOfClass:[NSNull class]]){
		self.totalCashAmount = [dictionary[kTHNAllinaceDataTotalCashAmount] floatValue];
	}

	if(![dictionary[kTHNAllinaceDataTotalCount] isKindOfClass:[NSNull class]]){
		self.totalCount = [dictionary[kTHNAllinaceDataTotalCount] integerValue];
	}

	if(![dictionary[kTHNAllinaceDataType] isKindOfClass:[NSNull class]]){
		self.type = [dictionary[kTHNAllinaceDataType] integerValue];
	}

	if(![dictionary[kTHNAllinaceDataUpdatedOn] isKindOfClass:[NSNull class]]){
		self.updatedOn = [dictionary[kTHNAllinaceDataUpdatedOn] integerValue];
	}

	if(![dictionary[kTHNAllinaceDataWaitCashAmount] isKindOfClass:[NSNull class]]){
		self.waitCashAmount = [dictionary[kTHNAllinaceDataWaitCashAmount] floatValue];
	}

	if(![dictionary[kTHNAllinaceDataWhetherApplyCash] isKindOfClass:[NSNull class]]){
		self.whetherApplyCash = [dictionary[kTHNAllinaceDataWhetherApplyCash] integerValue];
	}

	if(![dictionary[kTHNAllinaceDataWhetherBalanceStat] isKindOfClass:[NSNull class]]){
		self.whetherBalanceStat = [dictionary[kTHNAllinaceDataWhetherBalanceStat] integerValue];
	}

	return self;
}
@end
