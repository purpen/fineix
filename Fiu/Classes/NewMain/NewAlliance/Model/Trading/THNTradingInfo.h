//
//	THNTradingInfo.h
// on 18/1/2017
//	Copyright © 2017. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "THNTradingInfoData.h"

@interface THNTradingInfo : NSObject

@property (nonatomic, assign) NSInteger currentUserId;
@property (nonatomic, strong) THNTradingInfoData * data;
@property (nonatomic, assign) BOOL isError;
@property (nonatomic, strong) NSString * message;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, assign) BOOL success;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
