//
//	THNTradingInfoProduct.m
// on 18/1/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNTradingInfoProduct.h"

NSString *const kTHNTradingInfoProductShortTitle = @"short_title";
NSString *const kTHNTradingInfoProductTitle = @"title";

@interface THNTradingInfoProduct ()
@end
@implementation THNTradingInfoProduct




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNTradingInfoProductShortTitle] isKindOfClass:[NSNull class]]){
		self.shortTitle = dictionary[kTHNTradingInfoProductShortTitle];
	}	
	if(![dictionary[kTHNTradingInfoProductTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kTHNTradingInfoProductTitle];
	}	
	return self;
}
@end
