//
//	THNTradingRow.h
// on 18/1/2017
//	Copyright © 2017. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>

@interface THNTradingRow : NSObject

@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * allianceId;
@property (nonatomic, assign) NSInteger balanceOn;
@property (nonatomic, strong) NSString * code;
@property (nonatomic, assign) CGFloat commisionPercent;
@property (nonatomic, strong) NSString * createdAt;
@property (nonatomic, assign) NSInteger createdOn;
@property (nonatomic, assign) NSInteger fromSite;
@property (nonatomic, assign) NSInteger kind;
@property (nonatomic, strong) NSString * orderRid;
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, assign) NSInteger skuId;
@property (nonatomic, assign) NSInteger stage;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * statusLabel;
@property (nonatomic, assign) NSInteger subOrderId;
@property (nonatomic, assign) NSInteger summary;
@property (nonatomic, assign) CGFloat totalPrice;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) CGFloat unitPrice;
@property (nonatomic, assign) NSInteger updatedOn;
@property (nonatomic, assign) NSInteger userId;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end