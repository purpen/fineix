//
//	THNSettlementInfoBalance.h
// on 18/1/2017
//	Copyright © 2017. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "THNSettlementInfoProduct.h"

@interface THNSettlementInfoBalance : NSObject

@property (nonatomic, assign) BOOL extend;
@property (nonatomic, strong) NSString * idField;
@property (nonatomic, assign) NSInteger addition;
@property (nonatomic, strong) NSString * allianceId;
@property (nonatomic, assign) NSInteger balanceOn;
@property (nonatomic, strong) NSString * code;
@property (nonatomic, assign) CGFloat commisionPercent;
@property (nonatomic, assign) NSInteger commisionPercentP;
@property (nonatomic, assign) NSInteger createdOn;
@property (nonatomic, assign) NSInteger fromSite;
@property (nonatomic, assign) NSInteger kind;
@property (nonatomic, strong) NSString * kindLabel;
@property (nonatomic, strong) NSString * orderRid;
@property (nonatomic, strong) THNSettlementInfoProduct * product;
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, assign) NSInteger skuId;
@property (nonatomic, assign) CGFloat skuPrice;
@property (nonatomic, assign) NSInteger stage;
@property (nonatomic, strong) NSString * stageLabel;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * statusLabel;
@property (nonatomic, strong) NSObject * subOrderId;
@property (nonatomic, strong) NSObject * summary;
@property (nonatomic, assign) CGFloat totalPrice;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * typeLabel;
@property (nonatomic, assign) CGFloat unitPrice;
@property (nonatomic, assign) NSInteger updatedOn;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString * title;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
