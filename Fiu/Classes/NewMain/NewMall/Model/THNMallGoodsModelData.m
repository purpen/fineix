//
//	THNMallGoodsModelData.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNMallGoodsModelData.h"

NSString *const kTHNMallGoodsModelDataCurrentUserId = @"current_user_id";
NSString *const kTHNMallGoodsModelDataItems = @"items";

@interface THNMallGoodsModelData ()
@end
@implementation THNMallGoodsModelData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNMallGoodsModelDataCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kTHNMallGoodsModelDataCurrentUserId] integerValue];
	}

	if(dictionary[kTHNMallGoodsModelDataItems] != nil && [dictionary[kTHNMallGoodsModelDataItems] isKindOfClass:[NSArray class]]){
		NSArray * itemsDictionaries = dictionary[kTHNMallGoodsModelDataItems];
		NSMutableArray * itemsItems = [NSMutableArray array];
		for(NSDictionary * itemsDictionary in itemsDictionaries){
			THNMallGoodsModelItem * itemsItem = [[THNMallGoodsModelItem alloc] initWithDictionary:itemsDictionary];
			[itemsItems addObject:itemsItem];
		}
		self.items = itemsItems;
	}
	return self;
}
@end