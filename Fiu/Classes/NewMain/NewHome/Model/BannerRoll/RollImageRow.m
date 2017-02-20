//
//	RollImageRow.m
// on 3/5/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "RollImageRow.h"

@interface RollImageRow ()
@end
@implementation RollImageRow

/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"_id"] isKindOfClass:[NSNull class]]){
		self.idField = [dictionary[@"_id"] integerValue];
	}

	if(![dictionary[@"cover_id"] isKindOfClass:[NSNull class]]){
		self.coverId = dictionary[@"cover_id"];
	}	
	if(![dictionary[@"cover_url"] isKindOfClass:[NSNull class]]){
		self.coverUrl = dictionary[@"cover_url"];
	}	
	if(![dictionary[@"created_on"] isKindOfClass:[NSNull class]]){
		self.createdOn = [dictionary[@"created_on"] integerValue];
	}

	if(![dictionary[@"kind"] isKindOfClass:[NSNull class]]){
		self.kind = [dictionary[@"kind"] integerValue];
	}

	if(![dictionary[@"ordby"] isKindOfClass:[NSNull class]]){
		self.ordby = [dictionary[@"ordby"] integerValue];
	}

	if(![dictionary[@"space_id"] isKindOfClass:[NSNull class]]){
		self.spaceId = [dictionary[@"space_id"] integerValue];
	}

	if(![dictionary[@"state"] isKindOfClass:[NSNull class]]){
		self.state = [dictionary[@"state"] integerValue];
	}

	if(![dictionary[@"sub_title"] isKindOfClass:[NSNull class]]){
		self.subTitle = dictionary[@"sub_title"];
	}	
	if(![dictionary[@"summary"] isKindOfClass:[NSNull class]]){
		self.summary = dictionary[@"summary"];
	}	
	if(![dictionary[@"title"] isKindOfClass:[NSNull class]]){
		self.title = dictionary[@"title"];
	}	
	if(![dictionary[@"type"] isKindOfClass:[NSNull class]]){
		self.type = dictionary[@"type"];
	}	
	if(![dictionary[@"web_url"] isKindOfClass:[NSNull class]]){
		self.webUrl = dictionary[@"web_url"];
	}	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.webUrl forKey:@"webUrl"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeInteger:self.idField forKey:@"id"];
    [aCoder encodeObject:self.coverId forKey:@"coverId"];
    [aCoder encodeObject:self.coverUrl forKey:@"coverUrl"];
    [aCoder encodeInteger:self.kind forKey:@"kind"];
    [aCoder encodeInteger:self.state forKey:@"state"];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.webUrl = [aDecoder decodeObjectForKey:@"webUrl"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.idField = [aDecoder decodeIntegerForKey:@"idField"];
        self.coverId = [aDecoder decodeObjectForKey:@"coverId"];
        self.coverUrl = [aDecoder decodeObjectForKey:@"coverUrl"];
        self.kind = [aDecoder decodeIntegerForKey:@"kind"];
        self.state = [aDecoder decodeIntegerForKey:@"state"];
    }
    return self;
}

@end
