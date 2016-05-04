//
//	TaoBaoGoodsResult.m
// on 4/5/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "TaoBaoGoodsResult.h"

@interface TaoBaoGoodsResult ()
@end
@implementation TaoBaoGoodsResult




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(dictionary[@"n_tbk_item"] != nil && [dictionary[@"n_tbk_item"] isKindOfClass:[NSArray class]]){
		NSArray * nTbkItemDictionaries = dictionary[@"n_tbk_item"];
		NSMutableArray * nTbkItemItems = [NSMutableArray array];
		for(NSDictionary * nTbkItemDictionary in nTbkItemDictionaries){
			TaoBaoGoodsNTbkItem * nTbkItemItem = [[TaoBaoGoodsNTbkItem alloc] initWithDictionary:nTbkItemDictionary];
			[nTbkItemItems addObject:nTbkItemItem];
		}
		self.nTbkItem = nTbkItemItems;
	}
	return self;
}
@end