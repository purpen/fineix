//
//	CommentId.m
// on 23/5/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "CommentId.h"

@interface CommentId ()
@end
@implementation CommentId




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[@"$id"] isKindOfClass:[NSNull class]]){
		self.idField = dictionary[@"$id"];
	}	
	return self;
}
@end