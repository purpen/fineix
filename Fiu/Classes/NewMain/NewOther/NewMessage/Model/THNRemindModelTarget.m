//
//	THNRemindModelTarget.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNRemindModelTarget.h"

NSString *const kTHNRemindModelTargetIdField = @"_id";
NSString *const kTHNRemindModelTargetContent = @"content";

@interface THNRemindModelTarget ()
@end
@implementation THNRemindModelTarget




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNRemindModelTargetIdField] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[kTHNRemindModelTargetIdField] integerValue];
	}

	if(![dictionary[kTHNRemindModelTargetContent] isKindOfClass:[NSNull class]]){
		self.content = dictionary[kTHNRemindModelTargetContent];
	}	
	return self;
}
@end