//
//	GoodsRow.m
// on 28/4/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "GoodsRow.h"

@interface GoodsRow ()
@end
@implementation GoodsRow




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
    
	if(![dictionary[@"_id"] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[@"_id"] integerValue];
	}

	if(![dictionary[@"attrbute"] isKindOfClass:[NSNull class]]){
		self.attrbute = [dictionary[@"attrbute"] integerValue];
	}

	if(![dictionary[@"banner_asset"] isKindOfClass:[NSNull class]]){
		self.bannerAsset = dictionary[@"banner_asset"];
	}
    if(![dictionary[@"banners"] isKindOfClass:[NSNull class]]){
        self.banner = dictionary[@"banners"];
    }
    if(![dictionary[@"sights"] isKindOfClass:[NSNull class]]){
        self.sights = dictionary[@"sights"];
    }
	if(![dictionary[@"banner_id"] isKindOfClass:[NSNull class]]){
		self.bannerId = [dictionary[@"banner_id"] integerValue];
	}

	if(![dictionary[@"brand_id"] isKindOfClass:[NSNull class]]){
		self.brandId = dictionary[@"brand_id"];
	}	
	if(![dictionary[@"buy_count"] isKindOfClass:[NSNull class]]){
		self.buyCount = [dictionary[@"buy_count"] integerValue];
	}

	if(![dictionary[@"category_id"] isKindOfClass:[NSNull class]]){
		self.categoryId = [dictionary[@"category_id"] integerValue];
	}

	if(![dictionary[@"category_tags"] isKindOfClass:[NSNull class]]){
		self.categoryTags = dictionary[@"category_tags"];
	}	
	if(![dictionary[@"comment_count"] isKindOfClass:[NSNull class]]){
		self.commentCount = [dictionary[@"comment_count"] integerValue];
	}

	if(![dictionary[@"cover_id"] isKindOfClass:[NSNull class]]){
		self.coverId = dictionary[@"cover_id"];
	}	
	if(![dictionary[@"cover_url"] isKindOfClass:[NSNull class]]){
		self.coverUrl = dictionary[@"cover_url"];
	}	
	if(![dictionary[@"created_at"] isKindOfClass:[NSNull class]]){
		self.createdAt = dictionary[@"created_at"];
	}	
	if(![dictionary[@"created_on"] isKindOfClass:[NSNull class]]){
		self.createdOn = [dictionary[@"created_on"] integerValue];
	}

	if(![dictionary[@"deleted"] isKindOfClass:[NSNull class]]){
		self.deleted = [dictionary[@"deleted"] integerValue];
	}

	if(![dictionary[@"favorite_count"] isKindOfClass:[NSNull class]]){
		self.favoriteCount = [dictionary[@"favorite_count"] integerValue];
	}

	if(![dictionary[@"fid"] isKindOfClass:[NSNull class]]){
		self.fid = [dictionary[@"fid"] integerValue];
	}

	if(![dictionary[@"fine"] isKindOfClass:[NSNull class]]){
		self.fine = [dictionary[@"fine"] integerValue];
	}

	if(![dictionary[@"kind"] isKindOfClass:[NSNull class]]){
		self.kind = [dictionary[@"kind"] integerValue];
	}

	if(![dictionary[@"link"] isKindOfClass:[NSNull class]]){
		self.link = dictionary[@"link"];
	}	
	if(![dictionary[@"love_count"] isKindOfClass:[NSNull class]]){
		self.loveCount = [dictionary[@"love_count"] integerValue];
	}

	if(![dictionary[@"market_price"] isKindOfClass:[NSNull class]]){
		self.marketPrice = [dictionary[@"market_price"] floatValue];
	}	
	if(![dictionary[@"oid"] isKindOfClass:[NSNull class]]){
		self.oid = dictionary[@"oid"];
	}	
	if(![dictionary[@"published"] isKindOfClass:[NSNull class]]){
		self.published = [dictionary[@"published"] integerValue];
	}

	if(![dictionary[@"sale_price"] isKindOfClass:[NSNull class]]){
		self.salePrice = [dictionary[@"sale_price"] floatValue];
	}	
	if(![dictionary[@"short_title"] isKindOfClass:[NSNull class]]){
		self.shortTitle = dictionary[@"short_title"];
	}	
	if(![dictionary[@"state"] isKindOfClass:[NSNull class]]){
		self.state = [dictionary[@"state"] integerValue];
	}

	if(![dictionary[@"stick"] isKindOfClass:[NSNull class]]){
		self.stick = [dictionary[@"stick"] integerValue];
	}

	if(![dictionary[@"summary"] isKindOfClass:[NSNull class]]){
		self.summary = dictionary[@"summary"];
	}	
	if(![dictionary[@"tags"] isKindOfClass:[NSNull class]]){
		self.tags = dictionary[@"tags"];
	}	
	if(![dictionary[@"tags_s"] isKindOfClass:[NSNull class]]){
		self.tagsS = dictionary[@"tags_s"];
	}	
	if(![dictionary[@"title"] isKindOfClass:[NSNull class]]){
		self.title = dictionary[@"title"];
	}	
	if(![dictionary[@"updated_on"] isKindOfClass:[NSNull class]]){
		self.updatedOn = [dictionary[@"updated_on"] integerValue];
	}

	if(![dictionary[@"view_count"] isKindOfClass:[NSNull class]]){
		self.viewCount = [dictionary[@"view_count"] integerValue];
	}

	return self;
}
@end