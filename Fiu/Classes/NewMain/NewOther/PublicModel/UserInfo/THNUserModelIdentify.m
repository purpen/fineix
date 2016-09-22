//
//	THNUserModelIdentify.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNUserModelIdentify.h"

NSString *const kTHNUserModelIdentifyIsExpert = @"is_expert";
NSString *const kTHNUserModelIdentifyIsSceneSubscribe = @"is_scene_subscribe";

@interface THNUserModelIdentify ()
@end
@implementation THNUserModelIdentify




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNUserModelIdentifyIsExpert] isKindOfClass:[NSNull class]]){
		self.isExpert = [dictionary[kTHNUserModelIdentifyIsExpert] integerValue];
	}

	if(![dictionary[kTHNUserModelIdentifyIsSceneSubscribe] isKindOfClass:[NSNull class]]){
		self.isSceneSubscribe = [dictionary[kTHNUserModelIdentifyIsSceneSubscribe] integerValue];
	}

	return self;
}
@end