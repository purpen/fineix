//
//	THNDomainManageInfoLocation.m
// on 10/3/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNDomainManageInfoLocation.h"

NSString *const kTHNDomainManageInfoLocationCoordinates = @"coordinates";
NSString *const kTHNDomainManageInfoLocationType = @"type";

@interface THNDomainManageInfoLocation ()
@end
@implementation THNDomainManageInfoLocation




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNDomainManageInfoLocationCoordinates] isKindOfClass:[NSNull class]]){
		self.coordinates = dictionary[kTHNDomainManageInfoLocationCoordinates];
	}	
	if(![dictionary[kTHNDomainManageInfoLocationType] isKindOfClass:[NSNull class]]){
		self.type = dictionary[kTHNDomainManageInfoLocationType];
	}	
	return self;
}
@end