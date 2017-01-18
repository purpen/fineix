//
//	THNSettlementInfoProduct.m
// on 18/1/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNSettlementInfoProduct.h"

NSString *const kTHNSettlementInfoProductShortTitle = @"short_title";
NSString *const kTHNSettlementInfoProductTitle = @"title";

@interface THNSettlementInfoProduct ()
@end
@implementation THNSettlementInfoProduct




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNSettlementInfoProductShortTitle] isKindOfClass:[NSNull class]]){
		self.shortTitle = dictionary[kTHNSettlementInfoProductShortTitle];
	}	
	if(![dictionary[kTHNSettlementInfoProductTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kTHNSettlementInfoProductTitle];
	}	
	return self;
}
@end