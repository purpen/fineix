//
//	THNRemindModelTargetObj.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNRemindModelTargetObj.h"

NSString *const kTHNRemindModelTargetObjIdField = @"_id";
NSString *const kTHNRemindModelTargetObjContent = @"content";
NSString *const kTHNRemindModelTargetObjCoverUrl = @"cover_url";

@interface THNRemindModelTargetObj ()
@end
@implementation THNRemindModelTargetObj




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNRemindModelTargetObjIdField] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[kTHNRemindModelTargetObjIdField] integerValue];
	}

	if(![dictionary[kTHNRemindModelTargetObjContent] isKindOfClass:[NSNull class]]){
		self.content = dictionary[kTHNRemindModelTargetObjContent];
	}	
	if(![dictionary[kTHNRemindModelTargetObjCoverUrl] isKindOfClass:[NSNull class]]){
		self.coverUrl = dictionary[kTHNRemindModelTargetObjCoverUrl];
	}	
	return self;
}
@end