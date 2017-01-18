//
//	THNAllinaceContact.m
// on 18/1/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "THNAllinaceContact.h"

NSString *const kTHNAllinaceContactCompanyName = @"company_name";
NSString *const kTHNAllinaceContactEmail = @"email";
NSString *const kTHNAllinaceContactName = @"name";
NSString *const kTHNAllinaceContactPhone = @"phone";
NSString *const kTHNAllinaceContactPosition = @"position";

@interface THNAllinaceContact ()
@end
@implementation THNAllinaceContact




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kTHNAllinaceContactCompanyName] isKindOfClass:[NSNull class]]){
		self.companyName = dictionary[kTHNAllinaceContactCompanyName];
	}	
	if(![dictionary[kTHNAllinaceContactEmail] isKindOfClass:[NSNull class]]){
		self.email = dictionary[kTHNAllinaceContactEmail];
	}	
	if(![dictionary[kTHNAllinaceContactName] isKindOfClass:[NSNull class]]){
		self.name = dictionary[kTHNAllinaceContactName];
	}	
	if(![dictionary[kTHNAllinaceContactPhone] isKindOfClass:[NSNull class]]){
		self.phone = dictionary[kTHNAllinaceContactPhone];
	}	
	if(![dictionary[kTHNAllinaceContactPosition] isKindOfClass:[NSNull class]]){
		self.position = dictionary[kTHNAllinaceContactPosition];
	}	
	return self;
}
@end
