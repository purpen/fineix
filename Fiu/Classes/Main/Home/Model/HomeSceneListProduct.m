//
//	HomeSceneListProduct.m
//  on 25/4/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "HomeSceneListProduct.h"

@interface HomeSceneListProduct ()
@end
@implementation HomeSceneListProduct




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"id"] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[@"id"] integerValue];
	}

	if(![dictionary[@"price"] isKindOfClass:[NSNull class]]){
		self.price = [dictionary[@"price"] integerValue];
	}

	if(![dictionary[@"title"] isKindOfClass:[NSNull class]]){
		self.title = dictionary[@"title"];
	}	
	if(![dictionary[@"x"] isKindOfClass:[NSNull class]]){
		self.x = [dictionary[@"x"] integerValue];
	}

	if(![dictionary[@"y"] isKindOfClass:[NSNull class]]){
		self.y = [dictionary[@"y"] integerValue];
	}

	return self;
}
@end