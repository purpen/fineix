//
//	THNDomainManageInfo.h
// on 10/3/2017
//	Copyright © 2017. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "THNDomainManageInfoData.h"

@interface THNDomainManageInfo : NSObject

@property (nonatomic, assign) NSInteger currentUserId;
@property (nonatomic, strong) THNDomainManageInfoData * data;
@property (nonatomic, assign) BOOL isError;
@property (nonatomic, strong) NSString * message;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, assign) BOOL success;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end