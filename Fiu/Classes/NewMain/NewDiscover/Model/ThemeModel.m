//
//	ThemeModel.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "ThemeModel.h"

NSString *const kThemeModelCurrentUserId = @"current_user_id";
NSString *const kThemeModelData = @"data";
NSString *const kThemeModelIsError = @"is_error";
NSString *const kThemeModelMessage = @"message";
NSString *const kThemeModelStatus = @"status";
NSString *const kThemeModelSuccess = @"success";

@interface ThemeModel ()
@end
@implementation ThemeModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kThemeModelCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kThemeModelCurrentUserId] integerValue];
	}

	if(![dictionary[kThemeModelData] isKindOfClass:[NSNull class]]){
		self.data = [[ThemeModelData alloc] initWithDictionary:dictionary[kThemeModelData]];
	}

	if(![dictionary[kThemeModelIsError] isKindOfClass:[NSNull class]]){
		self.isError = [dictionary[kThemeModelIsError] boolValue];
	}

	if(![dictionary[kThemeModelMessage] isKindOfClass:[NSNull class]]){
		self.message = dictionary[kThemeModelMessage];
	}	
	if(![dictionary[kThemeModelStatus] isKindOfClass:[NSNull class]]){
		self.status = dictionary[kThemeModelStatus];
	}	
	if(![dictionary[kThemeModelSuccess] isKindOfClass:[NSNull class]]){
		self.success = [dictionary[kThemeModelSuccess] boolValue];
	}

	return self;
}
@end