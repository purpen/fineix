//
//	HomeSceneListRow.m
// on 25/4/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "HomeSceneListRow.h"
#import "MJExtension.h"

@interface HomeSceneListRow ()
@end
@implementation HomeSceneListRow

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"createdAt" : @"created_at",
             @"coverUrl" : @"cover_url"
             };
}


/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"_id"] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[@"_id"] integerValue];
	}

    if(![dictionary[@"address"] isKindOfClass:[NSNull class]]){
        self.address = dictionary[@"address"];
    }
    if(![dictionary[@"city"] isKindOfClass:[NSNull class]]){
        self.city = dictionary[@"city"];
    }
	if(![dictionary[@"comment_count"] isKindOfClass:[NSNull class]]){
		self.commentCount = [dictionary[@"comment_count"] integerValue];
	}

	if(![dictionary[@"cover_url"] isKindOfClass:[NSNull class]]){
		self.coverUrl = dictionary[@"cover_url"];
	}	
	if(![dictionary[@"created_on"] isKindOfClass:[NSNull class]]){
		self.createdOn = [dictionary[@"created_on"] integerValue];
	}

	if(![dictionary[@"des"] isKindOfClass:[NSNull class]]){
		self.des = dictionary[@"des"];
	}	
    if(![dictionary[@"fine"] isKindOfClass:[NSNull class]]){
        self.fine = [dictionary[@"fine"] integerValue];
    }
    if(![dictionary[@"stick"] isKindOfClass:[NSNull class]]){
        self.stick = [dictionary[@"stick"] integerValue];
    }

    if(![dictionary[@"is_check"] isKindOfClass:[NSNull class]]){
        self.isCheck = [dictionary[@"is_check"] integerValue];
    }
    if(![dictionary[@"is_love"] isKindOfClass:[NSNull class]]){
        self.isLove = [dictionary[@"is_love"] integerValue];
    }
    if(![dictionary[@"is_favorite"] isKindOfClass:[NSNull class]]){
        self.isFavorite = [dictionary[@"is_favorite"] integerValue];
    }

	if(![dictionary[@"location"] isKindOfClass:[NSNull class]]){
		self.location = [[HomeSceneListLocation alloc] initWithDictionary:dictionary[@"location"]];
	}

	if(![dictionary[@"love_count"] isKindOfClass:[NSNull class]]){
		self.loveCount = [dictionary[@"love_count"] integerValue];
	}

	if(dictionary[@"product"] != nil && [dictionary[@"product"] isKindOfClass:[NSArray class]]){
		NSArray * productDictionaries = dictionary[@"product"];
		NSMutableArray * productItems = [NSMutableArray array];
		for(NSDictionary * productDictionary in productDictionaries){
			HomeSceneListProduct * productItem = [[HomeSceneListProduct alloc] initWithDictionary:productDictionary];
			[productItems addObject:productItem];
		}
		self.product = productItems;
	}
	if(![dictionary[@"scene_id"] isKindOfClass:[NSNull class]]){
		self.sceneId = [dictionary[@"scene_id"] integerValue];
	}

	if(![dictionary[@"status"] isKindOfClass:[NSNull class]]){
		self.status = [dictionary[@"status"] integerValue];
	}

	if(![dictionary[@"tags"] isKindOfClass:[NSNull class]]){
		self.tags = dictionary[@"tags"];
	}	
	if(![dictionary[@"title"] isKindOfClass:[NSNull class]]){
		self.title = dictionary[@"title"];
	}
    if(![dictionary[@"scene_title"] isKindOfClass:[NSNull class]]){
        self.sceneTitle = dictionary[@"scene_title"];
    }
	if(![dictionary[@"updated_on"] isKindOfClass:[NSNull class]]){
		self.updatedOn = [dictionary[@"updated_on"] integerValue];
	}
    if(![dictionary[@"created_at"] isKindOfClass:[NSNull class]]){
        self.createdAt = dictionary[@"created_at"];
    }

	if(![dictionary[@"used_count"] isKindOfClass:[NSNull class]]){
		self.usedCount = [dictionary[@"used_count"] integerValue];
	}

    if(![dictionary[@"user_info"] isKindOfClass:[NSNull class]]){
        self.user = [[HomeSceneListUser alloc] initWithDictionary:dictionary[@"user_info"]];
    }
    
    if(dictionary[@"comments"] != nil && [dictionary[@"comments"] isKindOfClass:[NSArray class]]){
        NSArray * commentsDictionaries = dictionary[@"comments"];
        NSMutableArray * commentsItems = [NSMutableArray array];
        for(NSDictionary * commentsDictionary in commentsDictionaries){
            HomeSceneListComments * commentsItem = [[HomeSceneListComments alloc] initWithDictionary:commentsDictionary];
            [commentsItems addObject:commentsItem];
        }
        self.comments = commentsItems;
    }

	if(![dictionary[@"user_id"] isKindOfClass:[NSNull class]]){
		self.userId = [dictionary[@"user_id"] integerValue];
	}

	if(![dictionary[@"view_count"] isKindOfClass:[NSNull class]]){
		self.viewCount = [dictionary[@"view_count"] integerValue];
	}
    if(![dictionary[@"products"] isKindOfClass:[NSNull class]]){
        self.products = dictionary[@"products"];
    }
    if(![dictionary[@"category_ids"] isKindOfClass:[NSNull class]]){
        self.category_ids = dictionary[@"category_ids"];
    }

	return self;
}
@end
