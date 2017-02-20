//
//	HelpUserRow.m
// on 20/2/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "HelpUserRow.h"

NSString *const kHelpUserRowIdField = @"_id";
NSString *const kHelpUserRowCoverId = @"cover_id";
NSString *const kHelpUserRowCoverUrl = @"cover_url";
NSString *const kHelpUserRowCreatedOn = @"created_on";
NSString *const kHelpUserRowKind = @"kind";
NSString *const kHelpUserRowOrdby = @"ordby";
NSString *const kHelpUserRowSpaceId = @"space_id";
NSString *const kHelpUserRowState = @"state";
NSString *const kHelpUserRowSubTitle = @"sub_title";
NSString *const kHelpUserRowSummary = @"summary";
NSString *const kHelpUserRowTitle = @"title";
NSString *const kHelpUserRowType = @"type";
NSString *const kHelpUserRowWebUrl = @"web_url";

@interface HelpUserRow ()
@end
@implementation HelpUserRow




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kHelpUserRowIdField] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[kHelpUserRowIdField] integerValue];
	}

	if(![dictionary[kHelpUserRowCoverId] isKindOfClass:[NSNull class]]){
		self.coverId = dictionary[kHelpUserRowCoverId];
	}	
	if(![dictionary[kHelpUserRowCoverUrl] isKindOfClass:[NSNull class]]){
		self.coverUrl = dictionary[kHelpUserRowCoverUrl];
	}	
	if(![dictionary[kHelpUserRowCreatedOn] isKindOfClass:[NSNull class]]){
		self.createdOn = [dictionary[kHelpUserRowCreatedOn] integerValue];
	}

	if(![dictionary[kHelpUserRowKind] isKindOfClass:[NSNull class]]){
		self.kind = [dictionary[kHelpUserRowKind] integerValue];
	}

	if(![dictionary[kHelpUserRowOrdby] isKindOfClass:[NSNull class]]){
		self.ordby = [dictionary[kHelpUserRowOrdby] integerValue];
	}

	if(![dictionary[kHelpUserRowSpaceId] isKindOfClass:[NSNull class]]){
		self.spaceId = [dictionary[kHelpUserRowSpaceId] integerValue];
	}

	if(![dictionary[kHelpUserRowState] isKindOfClass:[NSNull class]]){
		self.state = [dictionary[kHelpUserRowState] integerValue];
	}

	if(![dictionary[kHelpUserRowSubTitle] isKindOfClass:[NSNull class]]){
		self.subTitle = dictionary[kHelpUserRowSubTitle];
	}	
	if(![dictionary[kHelpUserRowSummary] isKindOfClass:[NSNull class]]){
		self.summary = dictionary[kHelpUserRowSummary];
	}	
	if(![dictionary[kHelpUserRowTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kHelpUserRowTitle];
	}	
	if(![dictionary[kHelpUserRowType] isKindOfClass:[NSNull class]]){
		self.type = dictionary[kHelpUserRowType];
	}	
	if(![dictionary[kHelpUserRowWebUrl] isKindOfClass:[NSNull class]]){
		self.webUrl = dictionary[kHelpUserRowWebUrl];
	}	
	return self;
}
@end
