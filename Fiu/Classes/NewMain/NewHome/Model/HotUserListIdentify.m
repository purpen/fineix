//
//	HotUserListIdentify.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "HotUserListIdentify.h"

NSString *const kHotUserListIdentifyIsExpert = @"is_expert";
NSString *const kHotUserListIdentifyIsSceneSubscribe = @"is_scene_subscribe";

@interface HotUserListIdentify ()
@end
@implementation HotUserListIdentify




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kHotUserListIdentifyIsExpert] isKindOfClass:[NSNull class]]){
		self.isExpert = [dictionary[kHotUserListIdentifyIsExpert] integerValue];
	}

	if(![dictionary[kHotUserListIdentifyIsSceneSubscribe] isKindOfClass:[NSNull class]]){
		self.isSceneSubscribe = [dictionary[kHotUserListIdentifyIsSceneSubscribe] integerValue];
	}

	return self;
}
@end