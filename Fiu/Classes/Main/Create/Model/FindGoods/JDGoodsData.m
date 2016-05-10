//
//	JDGoodsData.m
// on 10/5/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "JDGoodsData.h"

@interface JDGoodsData ()
@end
@implementation JDGoodsData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"code"] isKindOfClass:[NSNull class]]){
		self.code = dictionary[@"code"];
	}	
	if(![dictionary[@"current_user_id"] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[@"current_user_id"] integerValue];
	}

	if(dictionary[@"listproductbase_result"] != nil && [dictionary[@"listproductbase_result"] isKindOfClass:[NSArray class]]){
		NSArray * listproductbaseResultDictionaries = dictionary[@"listproductbase_result"];
		NSMutableArray * listproductbaseResultItems = [NSMutableArray array];
		for(NSDictionary * listproductbaseResultDictionary in listproductbaseResultDictionaries){
			JDGoodsListproductbaseResult * listproductbaseResultItem = [[JDGoodsListproductbaseResult alloc] initWithDictionary:listproductbaseResultDictionary];
			[listproductbaseResultItems addObject:listproductbaseResultItem];
		}
		self.listproductbaseResult = listproductbaseResultItems;
	}
	return self;
}
@end