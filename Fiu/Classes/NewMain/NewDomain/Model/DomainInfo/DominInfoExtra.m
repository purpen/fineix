//
//	DominInfoExtra.m
// on 17/2/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "DominInfoExtra.h"

NSString *const kDominInfoExtraShopHours = @"shop_hours";
NSString *const kDominInfoExtraTel = @"tel";

@interface DominInfoExtra ()
@end
@implementation DominInfoExtra




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kDominInfoExtraShopHours] isKindOfClass:[NSNull class]]){
		self.shopHours = dictionary[kDominInfoExtraShopHours];
	}	
	if(![dictionary[kDominInfoExtraTel] isKindOfClass:[NSNull class]]){
		self.tel = dictionary[kDominInfoExtraTel];
	}	
	return self;
}
@end
