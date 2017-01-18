//
//	THNAllinaceData.h
// on 18/1/2017
//	Copyright © 2017. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "THNAllinaceContact.h"

@interface THNAllinaceData : NSObject

@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) THNAllinaceContact * contact;
@property (nonatomic, assign) NSInteger createdOn;
@property (nonatomic, assign) NSInteger currentUserId;
@property (nonatomic, assign) NSInteger kind;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger successCount;
@property (nonatomic, strong) NSString * summary;
@property (nonatomic, assign) CGFloat totalBalanceAmount;
@property (nonatomic, assign) CGFloat totalCashAmount;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger updatedOn;
@property (nonatomic, assign) CGFloat waitCashAmount;
@property (nonatomic, assign) NSInteger whetherApplyCash;
@property (nonatomic, assign) NSInteger whetherBalanceStat;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
