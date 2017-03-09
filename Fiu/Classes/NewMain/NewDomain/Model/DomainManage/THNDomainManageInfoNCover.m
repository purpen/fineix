//
//	THNDomainManageInfoNCover.m
// on 9/3/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNDomainManageInfoNCover.h"

NSString *const kTHNDomainManageInfoNCoverIdField = @"id";
NSString *const kTHNDomainManageInfoNCoverUrl = @"url";

@interface THNDomainManageInfoNCover ()
@end
@implementation THNDomainManageInfoNCover




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNDomainManageInfoNCoverIdField] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[kTHNDomainManageInfoNCoverIdField];
	}	
	if(![dictionary[kTHNDomainManageInfoNCoverUrl] isKindOfClass:[NSNull class]]){
		self.url = dictionary[kTHNDomainManageInfoNCoverUrl];
	}	
	return self;
}
@end