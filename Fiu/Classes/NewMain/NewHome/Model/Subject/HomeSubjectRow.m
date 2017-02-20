//
//	HomeSubjectRow.m
// on 20/2/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "HomeSubjectRow.h"

NSString *const kHomeSubjectRowIdField = @"_id";
NSString *const kHomeSubjectRowAttendCount = @"attend_count";
NSString *const kHomeSubjectRowBannerUrl = @"banner_url";
NSString *const kHomeSubjectRowCoverUrl = @"cover_url";
NSString *const kHomeSubjectRowEvt = @"evt";
NSString *const kHomeSubjectRowShortTitle = @"short_title";
NSString *const kHomeSubjectRowTitle = @"title";
NSString *const kHomeSubjectRowType = @"type";
NSString *const kHomeSubjectRowTypeLabel = @"type_label";
NSString *const kHomeSubjectRowViewCount = @"view_count";

@interface HomeSubjectRow ()
@end
@implementation HomeSubjectRow




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kHomeSubjectRowIdField] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[kHomeSubjectRowIdField] integerValue];
	}

	if(![dictionary[kHomeSubjectRowAttendCount] isKindOfClass:[NSNull class]]){
		self.attendCount = [dictionary[kHomeSubjectRowAttendCount] integerValue];
	}

	if(![dictionary[kHomeSubjectRowBannerUrl] isKindOfClass:[NSNull class]]){
		self.bannerUrl = dictionary[kHomeSubjectRowBannerUrl];
	}	
	if(![dictionary[kHomeSubjectRowCoverUrl] isKindOfClass:[NSNull class]]){
		self.coverUrl = dictionary[kHomeSubjectRowCoverUrl];
	}	
	if(![dictionary[kHomeSubjectRowEvt] isKindOfClass:[NSNull class]]){
		self.evt = [dictionary[kHomeSubjectRowEvt] integerValue];
	}

	if(![dictionary[kHomeSubjectRowShortTitle] isKindOfClass:[NSNull class]]){
		self.shortTitle = dictionary[kHomeSubjectRowShortTitle];
	}	
	if(![dictionary[kHomeSubjectRowTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kHomeSubjectRowTitle];
	}	
	if(![dictionary[kHomeSubjectRowType] isKindOfClass:[NSNull class]]){
		self.type = [dictionary[kHomeSubjectRowType] integerValue];
	}

	if(![dictionary[kHomeSubjectRowTypeLabel] isKindOfClass:[NSNull class]]){
		self.typeLabel = dictionary[kHomeSubjectRowTypeLabel];
	}	
	if(![dictionary[kHomeSubjectRowViewCount] isKindOfClass:[NSNull class]]){
		self.viewCount = [dictionary[kHomeSubjectRowViewCount] integerValue];
	}

	return self;
}
@end