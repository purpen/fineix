//
//	FBGoodsInfoModelBrand.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "FBGoodsInfoModelBrand.h"

NSString *const kFBGoodsInfoModelBrandIdField = @"_id";
NSString *const kFBGoodsInfoModelBrandCoverUrl = @"cover_url";
NSString *const kFBGoodsInfoModelBrandTitle = @"title";

@interface FBGoodsInfoModelBrand ()
@end
@implementation FBGoodsInfoModelBrand




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kFBGoodsInfoModelBrandIdField] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[kFBGoodsInfoModelBrandIdField];
	}	
	if(![dictionary[kFBGoodsInfoModelBrandCoverUrl] isKindOfClass:[NSNull class]]){
		self.coverUrl = dictionary[kFBGoodsInfoModelBrandCoverUrl];
	}	
	if(![dictionary[kFBGoodsInfoModelBrandTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kFBGoodsInfoModelBrandTitle];
	}	
	return self;
}
@end