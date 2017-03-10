//
//	THNDomainManageInfoCategory.m
// on 10/3/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNDomainManageInfoCategory.h"

NSString *const kTHNDomainManageInfoCategoryIdField = @"_id";
NSString *const kTHNDomainManageInfoCategoryTitle = @"title";

@interface THNDomainManageInfoCategory ()
@end
@implementation THNDomainManageInfoCategory




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNDomainManageInfoCategoryIdField] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[kTHNDomainManageInfoCategoryIdField] integerValue];
	}

	if(![dictionary[kTHNDomainManageInfoCategoryTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kTHNDomainManageInfoCategoryTitle];
	}	
	return self;
}
@end