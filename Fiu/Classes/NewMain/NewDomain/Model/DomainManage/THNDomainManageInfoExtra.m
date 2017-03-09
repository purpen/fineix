//
//	THNDomainManageInfoExtra.m
// on 9/3/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNDomainManageInfoExtra.h"

NSString *const kTHNDomainManageInfoExtraShopHours = @"shop_hours";
NSString *const kTHNDomainManageInfoExtraTel = @"tel";

@interface THNDomainManageInfoExtra ()
@end
@implementation THNDomainManageInfoExtra




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNDomainManageInfoExtraShopHours] isKindOfClass:[NSNull class]]){
		self.shopHours = dictionary[kTHNDomainManageInfoExtraShopHours];
	}	
	if(![dictionary[kTHNDomainManageInfoExtraTel] isKindOfClass:[NSNull class]]){
		self.tel = dictionary[kTHNDomainManageInfoExtraTel];
	}	
	return self;
}
@end