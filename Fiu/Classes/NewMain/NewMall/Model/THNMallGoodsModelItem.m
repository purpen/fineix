//
//	THNMallGoodsModelItem.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNMallGoodsModelItem.h"

NSString *const kTHNMallGoodsModelItemIdField = @"_id";
NSString *const kTHNMallGoodsModelItemSalePrice = @"sale_price";
NSString *const kTHNMallGoodsModelItemBrandCoverUrl = @"brand_cover_url";
NSString *const kTHNMallGoodsModelItemBrandId = @"brand_id";
NSString *const kTHNMallGoodsModelItemCoverUrl = @"cover_url";
NSString *const kTHNMallGoodsModelItemTitle = @"title";

@interface THNMallGoodsModelItem ()
@end
@implementation THNMallGoodsModelItem




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNMallGoodsModelItemIdField] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[kTHNMallGoodsModelItemIdField] integerValue];
	}
    
    if(![dictionary[kTHNMallGoodsModelItemSalePrice] isKindOfClass:[NSNull class]]){
        self.salePrice = [dictionary[kTHNMallGoodsModelItemSalePrice] floatValue];
    }

	if(![dictionary[kTHNMallGoodsModelItemBrandCoverUrl] isKindOfClass:[NSNull class]]){
		self.brandCoverUrl = dictionary[kTHNMallGoodsModelItemBrandCoverUrl];
	}	
	if(![dictionary[kTHNMallGoodsModelItemBrandId] isKindOfClass:[NSNull class]]){
		self.brandId = dictionary[kTHNMallGoodsModelItemBrandId];
	}	
	if(![dictionary[kTHNMallGoodsModelItemCoverUrl] isKindOfClass:[NSNull class]]){
		self.coverUrl = dictionary[kTHNMallGoodsModelItemCoverUrl];
	}	
	if(![dictionary[kTHNMallGoodsModelItemTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kTHNMallGoodsModelItemTitle];
	}	
	return self;
}
@end
