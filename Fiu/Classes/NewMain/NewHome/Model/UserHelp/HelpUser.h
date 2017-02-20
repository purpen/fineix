//
//	HelpUser.h
// on 20/2/2017
//	Copyright © 2017. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "HelpUserData.h"

@interface HelpUser : NSObject

@property (nonatomic, assign) NSInteger currentUserId;
@property (nonatomic, strong) HelpUserData * data;
@property (nonatomic, assign) BOOL isError;
@property (nonatomic, strong) NSString * message;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, assign) BOOL success;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
