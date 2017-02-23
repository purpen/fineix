//
//	THNTradingInfoData.h
// on 18/1/2017
//	Copyright © 2017. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "THNTradingInfoProduct.h"

@interface THNTradingInfoData : NSObject

@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * allianceId;
@property (nonatomic, assign) NSInteger balanceOn;
@property (nonatomic, strong) NSString * code;
@property (nonatomic, assign) CGFloat commisionPercent;
@property (nonatomic, strong) NSString * createdAt;
@property (nonatomic, assign) NSInteger createdOn;
@property (nonatomic, assign) NSInteger currentUserId;
@property (nonatomic, assign) NSInteger fromSite;
@property (nonatomic, assign) NSInteger kind;
@property (nonatomic, strong) NSString * orderRid;
@property (nonatomic, strong) THNTradingInfoProduct * product;
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, assign) NSInteger skuId;
@property (nonatomic, assign) CGFloat skuPrice;
@property (nonatomic, assign) NSInteger stage;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * statusLabel;
@property (nonatomic, strong) NSString * subOrderId;
@property (nonatomic, strong) NSString * summary;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) CGFloat totalPrice;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) CGFloat unitPrice;
@property (nonatomic, assign) NSInteger updatedOn;
@property (nonatomic, assign) NSInteger userId;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
