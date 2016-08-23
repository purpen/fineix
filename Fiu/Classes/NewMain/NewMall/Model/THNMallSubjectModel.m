//
//	THNMallSubjectModel.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNMallSubjectModel.h"

NSString *const kTHNMallSubjectModelCurrentUserId = @"current_user_id";
NSString *const kTHNMallSubjectModelData = @"data";
NSString *const kTHNMallSubjectModelIsError = @"is_error";
NSString *const kTHNMallSubjectModelMessage = @"message";
NSString *const kTHNMallSubjectModelStatus = @"status";
NSString *const kTHNMallSubjectModelSuccess = @"success";

@interface THNMallSubjectModel ()
@end
@implementation THNMallSubjectModel




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNMallSubjectModelCurrentUserId] isKindOfClass:[NSNull class]]){
		self.currentUserId = [dictionary[kTHNMallSubjectModelCurrentUserId] integerValue];
	}

	if(![dictionary[kTHNMallSubjectModelData] isKindOfClass:[NSNull class]]){
		self.data = [[THNMallSubjectModelData alloc] initWithDictionary:dictionary[kTHNMallSubjectModelData]];
	}

	if(![dictionary[kTHNMallSubjectModelIsError] isKindOfClass:[NSNull class]]){
		self.isError = [dictionary[kTHNMallSubjectModelIsError] boolValue];
	}

	if(![dictionary[kTHNMallSubjectModelMessage] isKindOfClass:[NSNull class]]){
		self.message = dictionary[kTHNMallSubjectModelMessage];
	}	
	if(![dictionary[kTHNMallSubjectModelStatus] isKindOfClass:[NSNull class]]){
		self.status = dictionary[kTHNMallSubjectModelStatus];
	}	
	if(![dictionary[kTHNMallSubjectModelSuccess] isKindOfClass:[NSNull class]]){
		self.success = [dictionary[kTHNMallSubjectModelSuccess] boolValue];
	}

	return self;
}
@end