//
//	FiuPeopleIdentify.m
// on 14/5/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "FiuPeopleIdentify.h"

@interface FiuPeopleIdentify ()
@end
@implementation FiuPeopleIdentify




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"is_expert"] isKindOfClass:[NSNull class]]){
		self.isExpert = [dictionary[@"is_expert"] integerValue];
	}

	if(![dictionary[@"is_scene_subscribe"] isKindOfClass:[NSNull class]]){
		self.isSceneSubscribe = [dictionary[@"is_scene_subscribe"] integerValue];
	}

	return self;
}
@end