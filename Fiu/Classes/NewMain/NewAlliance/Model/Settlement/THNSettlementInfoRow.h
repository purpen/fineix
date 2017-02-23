//
//	THNSettlementInfoRow.h
// on 18/1/2017
//	Copyright © 2017. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "THNSettlementInfoBalance.h"

@interface THNSettlementInfoRow : NSObject

@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * allianceId;
@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, strong) THNSettlementInfoBalance * balance;
@property (nonatomic, strong) NSString * balanceId;
@property (nonatomic, strong) NSString * balanceRecordId;
@property (nonatomic, strong) NSString * createdAt;
@property (nonatomic, assign) NSInteger createdOn;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger updatedOn;
@property (nonatomic, assign) NSInteger userId;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
