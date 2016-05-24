//
//	HomeSceneListCounter.m
//  on 25/4/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "HomeSceneListCounter.h"

@interface HomeSceneListCounter ()
@end
@implementation HomeSceneListCounter




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"alert_count"] isKindOfClass:[NSNull class]]){
		self.alertCount = [dictionary[@"alert_count"] integerValue];
	}

	if(![dictionary[@"comment_count"] isKindOfClass:[NSNull class]]){
		self.commentCount = [dictionary[@"comment_count"] integerValue];
	}

	if(![dictionary[@"fans_count"] isKindOfClass:[NSNull class]]){
		self.fansCount = [dictionary[@"fans_count"] integerValue];
	}

	if(![dictionary[@"message_count"] isKindOfClass:[NSNull class]]){
		self.messageCount = [dictionary[@"message_count"] integerValue];
	}

	if(![dictionary[@"notice_count"] isKindOfClass:[NSNull class]]){
		self.noticeCount = [dictionary[@"notice_count"] integerValue];
	}

	if(![dictionary[@"people_count"] isKindOfClass:[NSNull class]]){
		self.peopleCount = [dictionary[@"people_count"] integerValue];
	}

	return self;
}
@end