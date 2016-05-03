//
//	SceneInfoLocation.m
// on 25/4/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "SceneInfoLocation.h"

@interface SceneInfoLocation ()
@end
@implementation SceneInfoLocation




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"coordinates"] isKindOfClass:[NSNull class]]){
		self.coordinates = dictionary[@"coordinates"];
	}	
	if(![dictionary[@"type"] isKindOfClass:[NSNull class]]){
		self.type = dictionary[@"type"];
	}	
	return self;
}
@end