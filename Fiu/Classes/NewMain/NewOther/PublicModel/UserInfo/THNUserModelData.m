//
//	THNUserModelData.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNUserModelData.h"

NSString *const kTHNUserModelDataIdField = @"_id";
NSString *const kTHNUserModelDataAddress = @"address";
NSString *const kTHNUserModelDataAge = @"age";
NSString *const kTHNUserModelDataAgeGroup = @"age_group";
NSString *const kTHNUserModelDataAreas = @"areas";
NSString *const kTHNUserModelDataAssets = @"assets";
NSString *const kTHNUserModelDataBirdCoin = @"bird_coin";
NSString *const kTHNUserModelDataBirthday = @"birthday";
NSString *const kTHNUserModelDataCity = @"city";
NSString *const kTHNUserModelDataCounter = @"counter";
NSString *const kTHNUserModelDataCreatedOn = @"created_on";
NSString *const kTHNUserModelDataCurrentUserId = @"current_user_id";
NSString *const kTHNUserModelDataDistrictId = @"district_id";
NSString *const kTHNUserModelDataEmail = @"email";
NSString *const kTHNUserModelDataExpertInfo = @"expert_info";
NSString *const kTHNUserModelDataExpertLabel = @"expert_label";
NSString *const kTHNUserModelDataFansCount = @"fans_count";
NSString *const kTHNUserModelDataFirstLogin = @"first_login";
NSString *const kTHNUserModelDataFollowCount = @"follow_count";
NSString *const kTHNUserModelDataHeadPicUrl = @"head_pic_url";
NSString *const kTHNUserModelDataIdentify = @"identify";
NSString *const kTHNUserModelDataImQq = @"im_qq";
NSString *const kTHNUserModelDataInterestSceneCate = @"interest_scene_cate";
NSString *const kTHNUserModelDataIsLove = @"is_love";
NSString *const kTHNUserModelDataJob = @"job";
NSString *const kTHNUserModelDataLabel = @"label";
NSString *const kTHNUserModelDataMediumAvatarUrl = @"medium_avatar_url";
NSString *const kTHNUserModelDataNickname = @"nickname";
NSString *const kTHNUserModelDataPhone = @"phone";
NSString *const kTHNUserModelDataProvinceId = @"province_id";
NSString *const kTHNUserModelDataRankId = @"rank_id";
NSString *const kTHNUserModelDataRankTitle = @"rank_title";
NSString *const kTHNUserModelDataRealname = @"realname";
NSString *const kTHNUserModelDataSceneCount = @"scene_count";
NSString *const kTHNUserModelDataSex = @"sex";
NSString *const kTHNUserModelDataSightCount = @"sight_count";
NSString *const kTHNUserModelDataSightLoveCount = @"sight_love_count";
NSString *const kTHNUserModelDataState = @"state";
NSString *const kTHNUserModelDataSubscriptionCount = @"subscription_count";
NSString *const kTHNUserModelDataSummary = @"summary";
NSString *const kTHNUserModelDataTrueNickname = @"true_nickname";
NSString *const kTHNUserModelDataWeixin = @"weixin";
NSString *const kTHNUserModelDataZip = @"zip";

@interface THNUserModelData ()
@end
@implementation THNUserModelData




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNUserModelDataIdField] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[kTHNUserModelDataIdField] integerValue];
	}

	if(![dictionary[kTHNUserModelDataAddress] isKindOfClass:[NSNull class]]){
		self.address = dictionary[kTHNUserModelDataAddress];
	}	
	if(![dictionary[kTHNUserModelDataAge] isKindOfClass:[NSNull class]]){
		self.age = dictionary[kTHNUserModelDataAge];
	}	
	if(![dictionary[kTHNUserModelDataAgeGroup] isKindOfClass:[NSNull class]]){
		self.ageGroup = dictionary[kTHNUserModelDataAgeGroup];
	}	
	if(![dictionary[kTHNUserModelDataAreas] isKindOfClass:[NSNull class]]){
		self.areas = dictionary[kTHNUserModelDataAreas];
	}	
	if(![dictionary[kTHNUserModelDataAssets] isKindOfClass:[NSNull class]]){
		self.assets = dictionary[kTHNUserModelDataAssets];
	}	
	if(![dictionary[kTHNUserModelDataBirdCoin] isKindOfClass:[NSNull class]]){
		self.birdCoin = [dictionary[kTHNUserModelDataBirdCoin] integerValue];
	}

	if(![dictionary[kTHNUserModelDataBirthday] isKindOfClass:[NSNull class]]){
		self.birthday = dictionary[kTHNUserModelDataBirthday];
	}	
	if(![dictionary[kTHNUserModelDataCity] isKindOfClass:[NSNull class]]){
		self.city = dictionary[kTHNUserModelDataCity];
	}	
	if(![dictionary[kTHNUserModelDataCounter] isKindOfClass:[NSNull class]]){
		self.counter = [[THNUserModelCounter alloc] initWithDictionary:dictionary[kTHNUserModelDataCounter]];
	}

	if(![dictionary[kTHNUserModelDataCreatedOn] isKindOfClass:[NSNull class]]){
		self.createdOn = [dictionary[kTHNUserModelDataCreatedOn] integerValue];
	}

	if(![dictionary[kTHNUserModelDataCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kTHNUserModelDataCurrentUserId] integerValue];
	}

	if(![dictionary[kTHNUserModelDataDistrictId] isKindOfClass:[NSNull class]]){
		self.districtId = [dictionary[kTHNUserModelDataDistrictId] integerValue];
	}

	if(![dictionary[kTHNUserModelDataEmail] isKindOfClass:[NSNull class]]){
		self.email = dictionary[kTHNUserModelDataEmail];
	}	
	if(![dictionary[kTHNUserModelDataExpertInfo] isKindOfClass:[NSNull class]]){
		self.expertInfo = dictionary[kTHNUserModelDataExpertInfo];
	}	
	if(![dictionary[kTHNUserModelDataExpertLabel] isKindOfClass:[NSNull class]]){
		self.expertLabel = dictionary[kTHNUserModelDataExpertLabel];
	}	
	if(![dictionary[kTHNUserModelDataFansCount] isKindOfClass:[NSNull class]]){
		self.fansCount = [dictionary[kTHNUserModelDataFansCount] integerValue];
	}

	if(![dictionary[kTHNUserModelDataFirstLogin] isKindOfClass:[NSNull class]]){
		self.firstLogin = [dictionary[kTHNUserModelDataFirstLogin] integerValue];
	}

	if(![dictionary[kTHNUserModelDataFollowCount] isKindOfClass:[NSNull class]]){
		self.followCount = [dictionary[kTHNUserModelDataFollowCount] integerValue];
	}

	if(![dictionary[kTHNUserModelDataHeadPicUrl] isKindOfClass:[NSNull class]]){
		self.headPicUrl = dictionary[kTHNUserModelDataHeadPicUrl];
	}	
	if(![dictionary[kTHNUserModelDataIdentify] isKindOfClass:[NSNull class]]){
		self.identify = [[THNUserModelIdentify alloc] initWithDictionary:dictionary[kTHNUserModelDataIdentify]];
	}

	if(![dictionary[kTHNUserModelDataImQq] isKindOfClass:[NSNull class]]){
		self.imQq = dictionary[kTHNUserModelDataImQq];
	}	
	if(![dictionary[kTHNUserModelDataInterestSceneCate] isKindOfClass:[NSNull class]]){
		self.interestSceneCate = dictionary[kTHNUserModelDataInterestSceneCate];
	}	
	if(![dictionary[kTHNUserModelDataIsLove] isKindOfClass:[NSNull class]]){
		self.isLove = [dictionary[kTHNUserModelDataIsLove] integerValue];
	}

	if(![dictionary[kTHNUserModelDataJob] isKindOfClass:[NSNull class]]){
		self.job = dictionary[kTHNUserModelDataJob];
	}	
	if(![dictionary[kTHNUserModelDataLabel] isKindOfClass:[NSNull class]]){
		self.label = dictionary[kTHNUserModelDataLabel];
	}	
	if(![dictionary[kTHNUserModelDataMediumAvatarUrl] isKindOfClass:[NSNull class]]){
		self.mediumAvatarUrl = dictionary[kTHNUserModelDataMediumAvatarUrl];
	}	
	if(![dictionary[kTHNUserModelDataNickname] isKindOfClass:[NSNull class]]){
		self.nickname = dictionary[kTHNUserModelDataNickname];
	}	
	if(![dictionary[kTHNUserModelDataPhone] isKindOfClass:[NSNull class]]){
		self.phone = dictionary[kTHNUserModelDataPhone];
	}	
	if(![dictionary[kTHNUserModelDataProvinceId] isKindOfClass:[NSNull class]]){
		self.provinceId = [dictionary[kTHNUserModelDataProvinceId] integerValue];
	}

	if(![dictionary[kTHNUserModelDataRankId] isKindOfClass:[NSNull class]]){
		self.rankId = [dictionary[kTHNUserModelDataRankId] integerValue];
	}

	if(![dictionary[kTHNUserModelDataRankTitle] isKindOfClass:[NSNull class]]){
		self.rankTitle = dictionary[kTHNUserModelDataRankTitle];
	}	
	if(![dictionary[kTHNUserModelDataRealname] isKindOfClass:[NSNull class]]){
		self.realname = dictionary[kTHNUserModelDataRealname];
	}	
	if(![dictionary[kTHNUserModelDataSceneCount] isKindOfClass:[NSNull class]]){
		self.sceneCount = [dictionary[kTHNUserModelDataSceneCount] integerValue];
	}

	if(![dictionary[kTHNUserModelDataSex] isKindOfClass:[NSNull class]]){
		self.sex = [dictionary[kTHNUserModelDataSex] integerValue];
	}

	if(![dictionary[kTHNUserModelDataSightCount] isKindOfClass:[NSNull class]]){
		self.sightCount = [dictionary[kTHNUserModelDataSightCount] integerValue];
	}

	if(![dictionary[kTHNUserModelDataSightLoveCount] isKindOfClass:[NSNull class]]){
		self.sightLoveCount = [dictionary[kTHNUserModelDataSightLoveCount] integerValue];
	}

	if(![dictionary[kTHNUserModelDataState] isKindOfClass:[NSNull class]]){
		self.state = [dictionary[kTHNUserModelDataState] integerValue];
	}

	if(![dictionary[kTHNUserModelDataSubscriptionCount] isKindOfClass:[NSNull class]]){
		self.subscriptionCount = [dictionary[kTHNUserModelDataSubscriptionCount] integerValue];
	}

	if(![dictionary[kTHNUserModelDataSummary] isKindOfClass:[NSNull class]]){
		self.summary = dictionary[kTHNUserModelDataSummary];
	}	
	if(![dictionary[kTHNUserModelDataTrueNickname] isKindOfClass:[NSNull class]]){
		self.trueNickname = dictionary[kTHNUserModelDataTrueNickname];
	}	
	if(![dictionary[kTHNUserModelDataWeixin] isKindOfClass:[NSNull class]]){
		self.weixin = dictionary[kTHNUserModelDataWeixin];
	}	
	if(![dictionary[kTHNUserModelDataZip] isKindOfClass:[NSNull class]]){
		self.zip = dictionary[kTHNUserModelDataZip];
	}	
	return self;
}
@end