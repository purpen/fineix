//
//	DomainCategoryRow.m
// on 20/2/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "DomainCategoryRow.h"

NSString *const kDomainCategoryRowIdField = @"_id";
NSString *const kDomainCategoryRowAppCoverUrl = @"app_cover_url";
NSString *const kDomainCategoryRowBackUrl = @"back_url";
NSString *const kDomainCategoryRowDomain = @"domain";
NSString *const kDomainCategoryRowGid = @"gid";
NSString *const kDomainCategoryRowName = @"name";
NSString *const kDomainCategoryRowOrderBy = @"order_by";
NSString *const kDomainCategoryRowPid = @"pid";
NSString *const kDomainCategoryRowReplyCount = @"reply_count";
NSString *const kDomainCategoryRowStick = @"stick";
NSString *const kDomainCategoryRowSubCategories = @"sub_categories";
NSString *const kDomainCategoryRowSubCount = @"sub_count";
NSString *const kDomainCategoryRowTagId = @"tag_id";
NSString *const kDomainCategoryRowTags = @"tags";
NSString *const kDomainCategoryRowTitle = @"title";
NSString *const kDomainCategoryRowTotalCount = @"total_count";

@interface DomainCategoryRow ()
@end
@implementation DomainCategoryRow




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kDomainCategoryRowIdField] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[kDomainCategoryRowIdField] integerValue];
	}

	if(![dictionary[kDomainCategoryRowAppCoverUrl] isKindOfClass:[NSNull class]]){
		self.appCoverUrl = dictionary[kDomainCategoryRowAppCoverUrl];
	}	
	if(![dictionary[kDomainCategoryRowBackUrl] isKindOfClass:[NSNull class]]){
		self.backUrl = dictionary[kDomainCategoryRowBackUrl];
	}	
	if(![dictionary[kDomainCategoryRowDomain] isKindOfClass:[NSNull class]]){
		self.domain = [dictionary[kDomainCategoryRowDomain] integerValue];
	}

	if(![dictionary[kDomainCategoryRowGid] isKindOfClass:[NSNull class]]){
		self.gid = [dictionary[kDomainCategoryRowGid] integerValue];
	}

	if(![dictionary[kDomainCategoryRowName] isKindOfClass:[NSNull class]]){
		self.name = dictionary[kDomainCategoryRowName];
	}	
	if(![dictionary[kDomainCategoryRowOrderBy] isKindOfClass:[NSNull class]]){
		self.orderBy = [dictionary[kDomainCategoryRowOrderBy] integerValue];
	}

	if(![dictionary[kDomainCategoryRowPid] isKindOfClass:[NSNull class]]){
		self.pid = [dictionary[kDomainCategoryRowPid] integerValue];
	}

	if(![dictionary[kDomainCategoryRowReplyCount] isKindOfClass:[NSNull class]]){
		self.replyCount = [dictionary[kDomainCategoryRowReplyCount] integerValue];
	}

	if(![dictionary[kDomainCategoryRowStick] isKindOfClass:[NSNull class]]){
		self.stick = [dictionary[kDomainCategoryRowStick] integerValue];
	}

	if(![dictionary[kDomainCategoryRowSubCategories] isKindOfClass:[NSNull class]]){
		self.subCategories = dictionary[kDomainCategoryRowSubCategories];
	}	
	if(![dictionary[kDomainCategoryRowSubCount] isKindOfClass:[NSNull class]]){
		self.subCount = [dictionary[kDomainCategoryRowSubCount] integerValue];
	}

	if(![dictionary[kDomainCategoryRowTagId] isKindOfClass:[NSNull class]]){
		self.tagId = [dictionary[kDomainCategoryRowTagId] integerValue];
	}

	if(![dictionary[kDomainCategoryRowTags] isKindOfClass:[NSNull class]]){
		self.tags = dictionary[kDomainCategoryRowTags];
	}	
	if(![dictionary[kDomainCategoryRowTitle] isKindOfClass:[NSNull class]]){
		self.title = dictionary[kDomainCategoryRowTitle];
	}	
	if(![dictionary[kDomainCategoryRowTotalCount] isKindOfClass:[NSNull class]]){
		self.totalCount = [dictionary[kDomainCategoryRowTotalCount] integerValue];
	}

	return self;
}
@end
