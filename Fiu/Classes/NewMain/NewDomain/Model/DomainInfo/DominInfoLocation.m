//
//	DominInfoLocation.m
// on 17/2/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "DominInfoLocation.h"

NSString *const kDominInfoLocationCoordinates = @"coordinates";
NSString *const kDominInfoLocationType = @"type";

@interface DominInfoLocation ()
@end
@implementation DominInfoLocation




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kDominInfoLocationCoordinates] isKindOfClass:[NSNull class]]){
		self.coordinates = dictionary[kDominInfoLocationCoordinates];
	}	
	if(![dictionary[kDominInfoLocationType] isKindOfClass:[NSNull class]]){
		self.type = dictionary[kDominInfoLocationType];
	}	
	return self;
}
@end
