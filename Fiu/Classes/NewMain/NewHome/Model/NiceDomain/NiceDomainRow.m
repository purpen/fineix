//
//	NiceDomainRow.m
// on 20/2/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "NiceDomainRow.h"

NSString *const kNiceDomainRowIdField = @"_id";
NSString *const kNiceDomainRowCoverId = @"cover_id";
NSString *const kNiceDomainRowCoverUrl = @"cover_url";
NSString *const kNiceDomainRowCreatedOn = @"created_on";
NSString *const kNiceDomainRowKind = @"kind";
NSString *const kNiceDomainRowOrdby = @"ordby";
NSString *const kNiceDomainRowSpaceId = @"space_id";
NSString *const kNiceDomainRowState = @"state";
NSString *const kNiceDomainRowSubTitle = @"sub_title";
NSString *const kNiceDomainRowSummary = @"summary";
NSString *const kNiceDomainRowTitle = @"title";
NSString *const kNiceDomainRowType = @"type";
NSString *const kNiceDomainRowWebUrl = @"web_url";

@interface NiceDomainRow ()
@end
@implementation NiceDomainRow




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kNiceDomainRowIdField] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[kNiceDomainRowIdField] integerValue];
	}

	if(![dictionary[kNiceDomainRowCoverId] isKindOfClass:[NSNull class]]){
		self.coverId = dictionary[kNiceDomainRowCoverId];
	}	
	if(![dictionary[kNiceDomainRowCoverUrl] isKindOfClass:[NSNull class]]){
		self.coverUrl = dictionary[kNiceDomainRowCoverUrl];
	}	
	if(![dictionary[kNiceDomainRowCreatedOn] isKindOfClass:[NSNull class]]){
		self.createdOn = [dictionary[kNiceDomainRowCreatedOn] integerValue];
	}

	if(![dictionary[kNiceDomainRowKind] isKindOfClass:[NSNull class]]){
		self.kind = [dictionary[kNiceDomainRowKind] integerValue];
	}

	if(![dictionary[kNiceDomainRowOrdby] isKindOfClass:[NSNull class]]){
		self.ordby = [dictionary[kNiceDomainRowOrdby] integerValue];
	}

	if(![dictionary[kNiceDomainRowSpaceId] isKindOfClass:[NSNull class]]){
		self.spaceId = [dictionary[kNiceDomainRowSpaceId] integerValue];
	}

	if(![dictionary[kNiceDomainRowState] isKindOfClass:[NSNull class]]){
		self.state = [dictionary[kNiceDomainRowState] integerValue];
	}

	if(![dictionary[kNiceDomainRowSubTitle] isKindOfClass:[NSNull class]]){
		self.subTitle = dictionary[kNiceDomainRowSubTitle];
	}	
	if(![dictionary[kNiceDomainRowSummary] isKindOfClass:[NSNull class]]){
		self.summary = dictionary[kNiceDomainRowSummary];
	}	
	if(![dictionary[kNiceDomainRowTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kNiceDomainRowTitle];
	}	
	if(![dictionary[kNiceDomainRowType] isKindOfClass:[NSNull class]]){
		self.type = dictionary[kNiceDomainRowType];
	}	
	if(![dictionary[kNiceDomainRowWebUrl] isKindOfClass:[NSNull class]]){
		self.webUrl = dictionary[kNiceDomainRowWebUrl];
	}	
	return self;
}
@end
