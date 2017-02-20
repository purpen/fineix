//
//	FBSubjectModel.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "FBSubjectModel.h"

NSString *const kFBSubjectModelCurrentUserId = @"current_user_id";
NSString *const kFBSubjectModelData = @"data";
NSString *const kFBSubjectModelIsError = @"is_error";
NSString *const kFBSubjectModelMessage = @"message";
NSString *const kFBSubjectModelStatus = @"status";
NSString *const kFBSubjectModelSuccess = @"success";

@interface FBSubjectModel ()
@end
@implementation FBSubjectModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kFBSubjectModelCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kFBSubjectModelCurrentUserId] integerValue];
	}

	if(![dictionary[kFBSubjectModelData] isKindOfClass:[NSNull class]]){
		self.data = [[FBSubjectModelData alloc] initWithDictionary:dictionary[kFBSubjectModelData]];
	}

	if(![dictionary[kFBSubjectModelIsError] isKindOfClass:[NSNull class]]){
		self.isError = [dictionary[kFBSubjectModelIsError] boolValue];
	}

	if(![dictionary[kFBSubjectModelMessage] isKindOfClass:[NSNull class]]){
		self.message = dictionary[kFBSubjectModelMessage];
	}	
	if(![dictionary[kFBSubjectModelStatus] isKindOfClass:[NSNull class]]){
		self.status = dictionary[kFBSubjectModelStatus];
	}	
	if(![dictionary[kFBSubjectModelSuccess] isKindOfClass:[NSNull class]]){
		self.success = [dictionary[kFBSubjectModelSuccess] boolValue];
	}

	return self;
}
@end