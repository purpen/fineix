//
//	THNMallSubjectModelProduct.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNMallSubjectModelProduct.h"

NSString *const kTHNMallSubjectModelProductIdField = @"_id";
NSString *const kTHNMallSubjectModelProductBannerUrl = @"banner_url";
NSString *const kTHNMallSubjectModelProductCoverUrl = @"cover_url";
NSString *const kTHNMallSubjectModelProductSummary = @"summary";
NSString *const kTHNMallSubjectModelProductTitle = @"title";
NSString *const kTHNMallGoodsModelItemSalePrice = @"sale_price";

@interface THNMallSubjectModelProduct ()
@end
@implementation THNMallSubjectModelProduct




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNMallSubjectModelProductIdField] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[kTHNMallSubjectModelProductIdField] integerValue];
	}
    if(![dictionary[kTHNMallGoodsModelItemSalePrice] isKindOfClass:[NSNull class]]){
        self.salePrice = [dictionary[kTHNMallGoodsModelItemSalePrice] integerValue];
    }
	if(![dictionary[kTHNMallSubjectModelProductBannerUrl] isKindOfClass:[NSNull class]]){
		self.bannerUrl = dictionary[kTHNMallSubjectModelProductBannerUrl];
	}
    if(![dictionary[kTHNMallSubjectModelProductCoverUrl] isKindOfClass:[NSNull class]]){
        self.coverUrl = dictionary[kTHNMallSubjectModelProductCoverUrl];
    }
	if(![dictionary[kTHNMallSubjectModelProductSummary] isKindOfClass:[NSNull class]]){
		self.summary = dictionary[kTHNMallSubjectModelProductSummary];
	}	
	if(![dictionary[kTHNMallSubjectModelProductTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kTHNMallSubjectModelProductTitle];
	}	
	return self;
}
@end