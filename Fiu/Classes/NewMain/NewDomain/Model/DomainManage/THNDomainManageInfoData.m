//
//	THNDomainManageInfoData.m
// on 10/3/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNDomainManageInfoData.h"

NSString *const kTHNDomainManageInfoDataIdField = @"_id";
NSString *const kTHNDomainManageInfoDataAddress = @"address";
NSString *const kTHNDomainManageInfoDataAvatarUrl = @"avatar_url";
NSString *const kTHNDomainManageInfoDataBanners = @"banners";
NSString *const kTHNDomainManageInfoDataBrightSpot = @"bright_spot";
NSString *const kTHNDomainManageInfoDataCategory = @"category";
NSString *const kTHNDomainManageInfoDataCategoryId = @"category_id";
NSString *const kTHNDomainManageInfoDataCity = @"city";
NSString *const kTHNDomainManageInfoDataCovers = @"covers";
NSString *const kTHNDomainManageInfoDataCreatedAt = @"created_at";
NSString *const kTHNDomainManageInfoDataCurrentUserId = @"current_user_id";
NSString *const kTHNDomainManageInfoDataDes = @"des";
NSString *const kTHNDomainManageInfoDataExtra = @"extra";
NSString *const kTHNDomainManageInfoDataIsFavorite = @"is_favorite";
NSString *const kTHNDomainManageInfoDataIsLove = @"is_love";
NSString *const kTHNDomainManageInfoDataLocation = @"location";
NSString *const kTHNDomainManageInfoDataLoveCount = @"love_count";
NSString *const kTHNDomainManageInfoDataNCovers = @"n_covers";
NSString *const kTHNDomainManageInfoDataScoreAverage = @"score_average";
NSString *const kTHNDomainManageInfoDataSubTitle = @"sub_title";
NSString *const kTHNDomainManageInfoDataTags = @"tags";
NSString *const kTHNDomainManageInfoDataTitle = @"title";
NSString *const kTHNDomainManageInfoDataUser = @"user";
NSString *const kTHNDomainManageInfoDataViewCount = @"view_count";
NSString *const kTHNDomainManageInfoDataViewUrl = @"view_url";

@interface THNDomainManageInfoData ()
@end
@implementation THNDomainManageInfoData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNDomainManageInfoDataIdField] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[kTHNDomainManageInfoDataIdField] integerValue];
	}

	if(![dictionary[kTHNDomainManageInfoDataAddress] isKindOfClass:[NSNull class]]){
		self.address = dictionary[kTHNDomainManageInfoDataAddress];
	}	
	if(![dictionary[kTHNDomainManageInfoDataAvatarUrl] isKindOfClass:[NSNull class]]){
		self.avatarUrl = dictionary[kTHNDomainManageInfoDataAvatarUrl];
	}	
	if(![dictionary[kTHNDomainManageInfoDataBanners] isKindOfClass:[NSNull class]]){
		self.banners = dictionary[kTHNDomainManageInfoDataBanners];
	}	
	if(![dictionary[kTHNDomainManageInfoDataBrightSpot] isKindOfClass:[NSNull class]]){
		self.brightSpot = dictionary[kTHNDomainManageInfoDataBrightSpot];
	}	
	if(![dictionary[kTHNDomainManageInfoDataCategory] isKindOfClass:[NSNull class]]){
		self.category = [[THNDomainManageInfoCategory alloc] initWithDictionary:dictionary[kTHNDomainManageInfoDataCategory]];
	}

	if(![dictionary[kTHNDomainManageInfoDataCategoryId] isKindOfClass:[NSNull class]]){
		self.categoryId = [dictionary[kTHNDomainManageInfoDataCategoryId] integerValue];
	}

	if(![dictionary[kTHNDomainManageInfoDataCity] isKindOfClass:[NSNull class]]){
		self.city = dictionary[kTHNDomainManageInfoDataCity];
	}	
	if(![dictionary[kTHNDomainManageInfoDataCovers] isKindOfClass:[NSNull class]]){
		self.covers = dictionary[kTHNDomainManageInfoDataCovers];
	}	
	if(![dictionary[kTHNDomainManageInfoDataCreatedAt] isKindOfClass:[NSNull class]]){
		self.createdAt = dictionary[kTHNDomainManageInfoDataCreatedAt];
	}	
	if(![dictionary[kTHNDomainManageInfoDataCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kTHNDomainManageInfoDataCurrentUserId] integerValue];
	}

	if(![dictionary[kTHNDomainManageInfoDataDes] isKindOfClass:[NSNull class]]){
		self.des = dictionary[kTHNDomainManageInfoDataDes];
	}	
	if(![dictionary[kTHNDomainManageInfoDataExtra] isKindOfClass:[NSNull class]]){
		self.extra = [[THNDomainManageInfoExtra alloc] initWithDictionary:dictionary[kTHNDomainManageInfoDataExtra]];
	}

	if(![dictionary[kTHNDomainManageInfoDataIsFavorite] isKindOfClass:[NSNull class]]){
		self.isFavorite = [dictionary[kTHNDomainManageInfoDataIsFavorite] integerValue];
	}

	if(![dictionary[kTHNDomainManageInfoDataIsLove] isKindOfClass:[NSNull class]]){
		self.isLove = [dictionary[kTHNDomainManageInfoDataIsLove] integerValue];
	}

	if(![dictionary[kTHNDomainManageInfoDataLocation] isKindOfClass:[NSNull class]]){
		self.location = [[THNDomainManageInfoLocation alloc] initWithDictionary:dictionary[kTHNDomainManageInfoDataLocation]];
	}

	if(![dictionary[kTHNDomainManageInfoDataLoveCount] isKindOfClass:[NSNull class]]){
		self.loveCount = [dictionary[kTHNDomainManageInfoDataLoveCount] integerValue];
	}

	if(dictionary[kTHNDomainManageInfoDataNCovers] != nil && [dictionary[kTHNDomainManageInfoDataNCovers] isKindOfClass:[NSArray class]]){
		NSArray * nCoversDictionaries = dictionary[kTHNDomainManageInfoDataNCovers];
		NSMutableArray * nCoversItems = [NSMutableArray array];
		for(NSDictionary * nCoversDictionary in nCoversDictionaries){
			THNDomainManageInfoNCover * nCoversItem = [[THNDomainManageInfoNCover alloc] initWithDictionary:nCoversDictionary];
			[nCoversItems addObject:nCoversItem];
		}
		self.nCovers = nCoversItems;
	}
	if(![dictionary[kTHNDomainManageInfoDataScoreAverage] isKindOfClass:[NSNull class]]){
		self.scoreAverage = [dictionary[kTHNDomainManageInfoDataScoreAverage] integerValue];
	}

	if(![dictionary[kTHNDomainManageInfoDataSubTitle] isKindOfClass:[NSNull class]]){
		self.subTitle = dictionary[kTHNDomainManageInfoDataSubTitle];
	}	
	if(![dictionary[kTHNDomainManageInfoDataTags] isKindOfClass:[NSNull class]]){
		self.tags = dictionary[kTHNDomainManageInfoDataTags];
	}	
	if(![dictionary[kTHNDomainManageInfoDataTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kTHNDomainManageInfoDataTitle];
	}	
	if(![dictionary[kTHNDomainManageInfoDataUser] isKindOfClass:[NSNull class]]){
		self.user = [[THNDomainManageInfoUser alloc] initWithDictionary:dictionary[kTHNDomainManageInfoDataUser]];
	}

	if(![dictionary[kTHNDomainManageInfoDataViewCount] isKindOfClass:[NSNull class]]){
		self.viewCount = [dictionary[kTHNDomainManageInfoDataViewCount] integerValue];
	}

	if(![dictionary[kTHNDomainManageInfoDataViewUrl] isKindOfClass:[NSNull class]]){
		self.viewUrl = dictionary[kTHNDomainManageInfoDataViewUrl];
	}	
	return self;
}
@end