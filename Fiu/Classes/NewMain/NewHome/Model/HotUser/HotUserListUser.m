//
//	HotUserListUser.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "HotUserListUser.h"

NSString *const kHotUserListUserIdField = @"_id";
NSString *const kHotUserListUserAddress = @"address";
NSString *const kHotUserListUserAge = @"age";
NSString *const kHotUserListUserAgeGroup = @"age_group";
NSString *const kHotUserListUserAreas = @"areas";
NSString *const kHotUserListUserAssets = @"assets";
NSString *const kHotUserListUserBirthday = @"birthday";
NSString *const kHotUserListUserBornPlace = @"born_place";
NSString *const kHotUserListUserCard = @"card";
NSString *const kHotUserListUserCity = @"city";
NSString *const kHotUserListUserCompany = @"company";
NSString *const kHotUserListUserCounter = @"counter";
NSString *const kHotUserListUserCreatedOn = @"created_on";
NSString *const kHotUserListUserDistrictId = @"district_id";
NSString *const kHotUserListUserEmail = @"email";
NSString *const kHotUserListUserExpertInfo = @"expert_info";
NSString *const kHotUserListUserExpertLabel = @"expert_label";
NSString *const kHotUserListUserFansCount = @"fans_count";
NSString *const kHotUserListUserFirstLogin = @"first_login";
NSString *const kHotUserListUserFollowCount = @"follow_count";
NSString *const kHotUserListUserHeadPicUrl = @"head_pic_url";
NSString *const kHotUserListUserHeight = @"height";
NSString *const kHotUserListUserIdentify = @"identify";
NSString *const kHotUserListUserImQq = @"im_qq";
NSString *const kHotUserListUserIndustry = @"industry";
NSString *const kHotUserListUserInterestSceneCate = @"interest_scene_cate";
NSString *const kHotUserListUserIsFollow = @"is_follow";
NSString *const kHotUserListUserIsLove = @"is_love";
NSString *const kHotUserListUserJob = @"job";
NSString *const kHotUserListUserLabel = @"label";
NSString *const kHotUserListUserMarital = @"marital";
NSString *const kHotUserListUserMediumAvatarUrl = @"medium_avatar_url";
NSString *const kHotUserListUserNation = @"nation";
NSString *const kHotUserListUserNickname = @"nickname";
NSString *const kHotUserListUserPhone = @"phone";
NSString *const kHotUserListUserProvinceId = @"province_id";
NSString *const kHotUserListUserRankId = @"rank_id";
NSString *const kHotUserListUserRankTitle = @"rank_title";
NSString *const kHotUserListUserRealname = @"realname";
NSString *const kHotUserListUserSceneCount = @"scene_count";
NSString *const kHotUserListUserSceneSight = @"scene_sight";
NSString *const kHotUserListUserSchool = @"school";
NSString *const kHotUserListUserSex = @"sex";
NSString *const kHotUserListUserSightCount = @"sight_count";
NSString *const kHotUserListUserSightLoveCount = @"sight_love_count";
NSString *const kHotUserListUserState = @"state";
NSString *const kHotUserListUserSubscriptionCount = @"subscription_count";
NSString *const kHotUserListUserSummary = @"summary";
NSString *const kHotUserListUserTrueNickname = @"true_nickname";
NSString *const kHotUserListUserWeight = @"weight";
NSString *const kHotUserListUserWeixin = @"weixin";
NSString *const kHotUserListUserZip = @"zip";

@interface HotUserListUser ()
@end
@implementation HotUserListUser




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kHotUserListUserIdField] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[kHotUserListUserIdField] integerValue];
	}

	if(![dictionary[kHotUserListUserAddress] isKindOfClass:[NSNull class]]){
		self.address = dictionary[kHotUserListUserAddress];
	}	
	if(![dictionary[kHotUserListUserAge] isKindOfClass:[NSNull class]]){
		self.age = dictionary[kHotUserListUserAge];
	}	
	if(![dictionary[kHotUserListUserAgeGroup] isKindOfClass:[NSNull class]]){
		self.ageGroup = dictionary[kHotUserListUserAgeGroup];
	}	
	if(![dictionary[kHotUserListUserAreas] isKindOfClass:[NSNull class]]){
		self.areas = dictionary[kHotUserListUserAreas];
	}	
	if(![dictionary[kHotUserListUserAssets] isKindOfClass:[NSNull class]]){
		self.assets = dictionary[kHotUserListUserAssets];
	}	
	if(![dictionary[kHotUserListUserBirthday] isKindOfClass:[NSNull class]]){
		self.birthday = dictionary[kHotUserListUserBirthday];
	}	
	if(![dictionary[kHotUserListUserBornPlace] isKindOfClass:[NSNull class]]){
		self.bornPlace = dictionary[kHotUserListUserBornPlace];
	}	
	if(![dictionary[kHotUserListUserCard] isKindOfClass:[NSNull class]]){
		self.card = dictionary[kHotUserListUserCard];
	}	
	if(![dictionary[kHotUserListUserCity] isKindOfClass:[NSNull class]]){
		self.city = dictionary[kHotUserListUserCity];
	}	
	if(![dictionary[kHotUserListUserCompany] isKindOfClass:[NSNull class]]){
		self.company = dictionary[kHotUserListUserCompany];
	}	
	if(![dictionary[kHotUserListUserCounter] isKindOfClass:[NSNull class]]){
		self.counter = [[HotUserListCounter alloc] initWithDictionary:dictionary[kHotUserListUserCounter]];
	}

	if(![dictionary[kHotUserListUserCreatedOn] isKindOfClass:[NSNull class]]){
		self.createdOn = [dictionary[kHotUserListUserCreatedOn] integerValue];
	}

	if(![dictionary[kHotUserListUserDistrictId] isKindOfClass:[NSNull class]]){
		self.districtId = [dictionary[kHotUserListUserDistrictId] integerValue];
	}

	if(![dictionary[kHotUserListUserEmail] isKindOfClass:[NSNull class]]){
		self.email = dictionary[kHotUserListUserEmail];
	}	
	if(![dictionary[kHotUserListUserExpertInfo] isKindOfClass:[NSNull class]]){
		self.expertInfo = dictionary[kHotUserListUserExpertInfo];
	}	
	if(![dictionary[kHotUserListUserExpertLabel] isKindOfClass:[NSNull class]]){
		self.expertLabel = dictionary[kHotUserListUserExpertLabel];
	}	
	if(![dictionary[kHotUserListUserFansCount] isKindOfClass:[NSNull class]]){
		self.fansCount = [dictionary[kHotUserListUserFansCount] integerValue];
	}

	if(![dictionary[kHotUserListUserFirstLogin] isKindOfClass:[NSNull class]]){
		self.firstLogin = [dictionary[kHotUserListUserFirstLogin] integerValue];
	}

	if(![dictionary[kHotUserListUserFollowCount] isKindOfClass:[NSNull class]]){
		self.followCount = [dictionary[kHotUserListUserFollowCount] integerValue];
	}

	if(![dictionary[kHotUserListUserHeadPicUrl] isKindOfClass:[NSNull class]]){
		self.headPicUrl = dictionary[kHotUserListUserHeadPicUrl];
	}	
	if(![dictionary[kHotUserListUserHeight] isKindOfClass:[NSNull class]]){
		self.height = dictionary[kHotUserListUserHeight];
	}	
	if(![dictionary[kHotUserListUserIdentify] isKindOfClass:[NSNull class]]){
		self.identify = [[HotUserListIdentify alloc] initWithDictionary:dictionary[kHotUserListUserIdentify]];
	}

	if(![dictionary[kHotUserListUserImQq] isKindOfClass:[NSNull class]]){
		self.imQq = dictionary[kHotUserListUserImQq];
	}	
	if(![dictionary[kHotUserListUserIndustry] isKindOfClass:[NSNull class]]){
		self.industry = dictionary[kHotUserListUserIndustry];
	}	
	if(![dictionary[kHotUserListUserInterestSceneCate] isKindOfClass:[NSNull class]]){
		self.interestSceneCate = dictionary[kHotUserListUserInterestSceneCate];
	}	
	if(![dictionary[kHotUserListUserIsFollow] isKindOfClass:[NSNull class]]){
		self.isFollow = [dictionary[kHotUserListUserIsFollow] integerValue];
	}

	if(![dictionary[kHotUserListUserIsLove] isKindOfClass:[NSNull class]]){
		self.isLove = [dictionary[kHotUserListUserIsLove] integerValue];
	}

	if(![dictionary[kHotUserListUserJob] isKindOfClass:[NSNull class]]){
		self.job = dictionary[kHotUserListUserJob];
	}	
	if(![dictionary[kHotUserListUserLabel] isKindOfClass:[NSNull class]]){
		self.label = dictionary[kHotUserListUserLabel];
	}	
	if(![dictionary[kHotUserListUserMarital] isKindOfClass:[NSNull class]]){
		self.marital = [dictionary[kHotUserListUserMarital] integerValue];
	}

	if(![dictionary[kHotUserListUserMediumAvatarUrl] isKindOfClass:[NSNull class]]){
		self.mediumAvatarUrl = dictionary[kHotUserListUserMediumAvatarUrl];
	}	
	if(![dictionary[kHotUserListUserNation] isKindOfClass:[NSNull class]]){
		self.nation = dictionary[kHotUserListUserNation];
	}	
	if(![dictionary[kHotUserListUserNickname] isKindOfClass:[NSNull class]]){
		self.nickname = dictionary[kHotUserListUserNickname];
	}	
	if(![dictionary[kHotUserListUserPhone] isKindOfClass:[NSNull class]]){
		self.phone = dictionary[kHotUserListUserPhone];
	}	
	if(![dictionary[kHotUserListUserProvinceId] isKindOfClass:[NSNull class]]){
		self.provinceId = [dictionary[kHotUserListUserProvinceId] integerValue];
	}

	if(![dictionary[kHotUserListUserRankId] isKindOfClass:[NSNull class]]){
		self.rankId = [dictionary[kHotUserListUserRankId] integerValue];
	}

	if(![dictionary[kHotUserListUserRankTitle] isKindOfClass:[NSNull class]]){
		self.rankTitle = dictionary[kHotUserListUserRankTitle];
	}	
	if(![dictionary[kHotUserListUserRealname] isKindOfClass:[NSNull class]]){
		self.realname = dictionary[kHotUserListUserRealname];
	}	
	if(![dictionary[kHotUserListUserSceneCount] isKindOfClass:[NSNull class]]){
		self.sceneCount = [dictionary[kHotUserListUserSceneCount] integerValue];
	}

	if(![dictionary[kHotUserListUserSceneSight] isKindOfClass:[NSNull class]]){
		self.sceneSight = dictionary[kHotUserListUserSceneSight];
	}	
	if(![dictionary[kHotUserListUserSchool] isKindOfClass:[NSNull class]]){
		self.school = dictionary[kHotUserListUserSchool];
	}	
	if(![dictionary[kHotUserListUserSex] isKindOfClass:[NSNull class]]){
		self.sex = [dictionary[kHotUserListUserSex] integerValue];
	}

	if(![dictionary[kHotUserListUserSightCount] isKindOfClass:[NSNull class]]){
		self.sightCount = [dictionary[kHotUserListUserSightCount] integerValue];
	}

	if(![dictionary[kHotUserListUserSightLoveCount] isKindOfClass:[NSNull class]]){
		self.sightLoveCount = [dictionary[kHotUserListUserSightLoveCount] integerValue];
	}

	if(![dictionary[kHotUserListUserState] isKindOfClass:[NSNull class]]){
		self.state = [dictionary[kHotUserListUserState] integerValue];
	}

	if(![dictionary[kHotUserListUserSubscriptionCount] isKindOfClass:[NSNull class]]){
		self.subscriptionCount = [dictionary[kHotUserListUserSubscriptionCount] integerValue];
	}

	if(![dictionary[kHotUserListUserSummary] isKindOfClass:[NSNull class]]){
		self.summary = dictionary[kHotUserListUserSummary];
	}	
	if(![dictionary[kHotUserListUserTrueNickname] isKindOfClass:[NSNull class]]){
		self.trueNickname = dictionary[kHotUserListUserTrueNickname];
	}	
	if(![dictionary[kHotUserListUserWeight] isKindOfClass:[NSNull class]]){
		self.weight = dictionary[kHotUserListUserWeight];
	}	
	if(![dictionary[kHotUserListUserWeixin] isKindOfClass:[NSNull class]]){
		self.weixin = dictionary[kHotUserListUserWeixin];
	}	
	if(![dictionary[kHotUserListUserZip] isKindOfClass:[NSNull class]]){
		self.zip = dictionary[kHotUserListUserZip];
	}	
	return self;
}
@end