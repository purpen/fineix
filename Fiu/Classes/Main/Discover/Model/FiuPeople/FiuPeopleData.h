//
//	FiuPeopleData.h
// on 14/5/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "FiuPeopleUser.h"

@interface FiuPeopleData : NSObject

@property (nonatomic, assign) NSInteger currentUserId;
@property (nonatomic, strong) NSArray * users;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end