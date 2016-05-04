//
//	TaoBaoGoodsSmallImage.m
// on 4/5/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "TaoBaoGoodsSmallImage.h"

@interface TaoBaoGoodsSmallImage ()
@end
@implementation TaoBaoGoodsSmallImage




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"string"] isKindOfClass:[NSNull class]]){
		self.string = dictionary[@"string"];
	}	
	return self;
}
@end