//
//	DominInfoData.m
// on 17/2/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "DominInfoData.h"

NSString *const kDominInfoDataIdField = @"_id";
NSString *const kDominInfoDataAddress = @"address";
NSString *const kDominInfoDataAvatarUrl = @"avatar_url";
NSString *const kDominInfoDataBanners = @"banners";
NSString *const kDominInfoDataBrightSpot = @"bright_spot";
NSString *const kDominInfoDataCity = @"city";
NSString *const kDominInfoDataCreatedAt = @"created_at";
NSString *const kDominInfoDataCurrentUserId = @"current_user_id";
NSString *const kDominInfoDataDes = @"des";
NSString *const kDominInfoDataExtra = @"extra";
NSString *const kDominInfoDataIsLove = @"is_love";
NSString *const kDominInfoDataIsFavorite = @"is_favorite";
NSString *const kDominInfoDataLocation = @"location";
NSString *const kDominInfoDataLoveCount = @"love_count";
NSString *const kDominInfoDataProducts = @"products";
NSString *const kDominInfoDataScoreAverage = @"score_average";
NSString *const kDominInfoDataSights = @"sights";
NSString *const kDominInfoDataSubTitle = @"sub_title";
NSString *const kDominInfoDataTags = @"tags";
NSString *const kDominInfoDataTitle = @"title";
NSString *const kDominInfoDataUser = @"user";
NSString *const kDominInfoDataViewCount = @"view_count";

@interface DominInfoData ()
@end
@implementation DominInfoData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kDominInfoDataIdField] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[kDominInfoDataIdField] integerValue];
	}

	if(![dictionary[kDominInfoDataAddress] isKindOfClass:[NSNull class]]){
		self.address = dictionary[kDominInfoDataAddress];
	}	
	if(![dictionary[kDominInfoDataAvatarUrl] isKindOfClass:[NSNull class]]){
		self.avatarUrl = dictionary[kDominInfoDataAvatarUrl];
	}	
	if(![dictionary[kDominInfoDataBanners] isKindOfClass:[NSNull class]]){
		self.banners = dictionary[kDominInfoDataBanners];
	}	
	if(![dictionary[kDominInfoDataBrightSpot] isKindOfClass:[NSNull class]]){
		self.brightSpot = dictionary[kDominInfoDataBrightSpot];
	}	
	if(![dictionary[kDominInfoDataCity] isKindOfClass:[NSNull class]]){
		self.city = dictionary[kDominInfoDataCity];
	}	
	if(![dictionary[kDominInfoDataCreatedAt] isKindOfClass:[NSNull class]]){
		self.createdAt = dictionary[kDominInfoDataCreatedAt];
	}	
	if(![dictionary[kDominInfoDataCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kDominInfoDataCurrentUserId] integerValue];
	}

	if(![dictionary[kDominInfoDataDes] isKindOfClass:[NSNull class]]){
		self.des = dictionary[kDominInfoDataDes];
	}	
	if(![dictionary[kDominInfoDataExtra] isKindOfClass:[NSNull class]]){
		self.extra = [[DominInfoExtra alloc] initWithDictionary:dictionary[kDominInfoDataExtra]];
	}

    if(![dictionary[kDominInfoDataIsLove] isKindOfClass:[NSNull class]]){
        self.isLove = [dictionary[kDominInfoDataIsLove] integerValue];
    }
    if(![dictionary[kDominInfoDataIsFavorite] isKindOfClass:[NSNull class]]){
        self.isFavorite = [dictionary[kDominInfoDataIsFavorite] integerValue];
    }

	if(![dictionary[kDominInfoDataLocation] isKindOfClass:[NSNull class]]){
		self.location = [[DominInfoLocation alloc] initWithDictionary:dictionary[kDominInfoDataLocation]];
	}

	if(![dictionary[kDominInfoDataLoveCount] isKindOfClass:[NSNull class]]){
		self.loveCount = [dictionary[kDominInfoDataLoveCount] integerValue];
	}

	if(![dictionary[kDominInfoDataProducts] isKindOfClass:[NSNull class]]){
		self.products = dictionary[kDominInfoDataProducts];
	}	
	if(![dictionary[kDominInfoDataScoreAverage] isKindOfClass:[NSNull class]]){
		self.scoreAverage = [dictionary[kDominInfoDataScoreAverage] integerValue];
	}

	if(![dictionary[kDominInfoDataSights] isKindOfClass:[NSNull class]]){
		self.sights = dictionary[kDominInfoDataSights];
	}	
	if(![dictionary[kDominInfoDataSubTitle] isKindOfClass:[NSNull class]]){
		self.subTitle = dictionary[kDominInfoDataSubTitle];
	}	
	if(![dictionary[kDominInfoDataTags] isKindOfClass:[NSNull class]]){
		self.tags = dictionary[kDominInfoDataTags];
	}	
	if(![dictionary[kDominInfoDataTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kDominInfoDataTitle];
	}	
	if(![dictionary[kDominInfoDataUser] isKindOfClass:[NSNull class]]){
		self.user = [[DominInfoUser alloc] initWithDictionary:dictionary[kDominInfoDataUser]];
	}

	if(![dictionary[kDominInfoDataViewCount] isKindOfClass:[NSNull class]]){
		self.viewCount = [dictionary[kDominInfoDataViewCount] integerValue];
	}

	return self;
}
@end
