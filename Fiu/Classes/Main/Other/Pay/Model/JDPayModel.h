//
//  JDPayModel.h
//  Fiu
//
//  Created by THN-Dong on 16/8/1.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDPayModel : NSObject

/**  */
@property (nonatomic, strong) NSString *callbackUrl;
/**  */
@property (nonatomic, strong) NSString *tradeDesc;
/**  */
@property (nonatomic, strong) NSString *tradeTime;
@property (nonatomic, strong) NSString *tradeNum;
/**  */
@property (nonatomic, strong) NSString *tradeName;

/**  */
@property (nonatomic, strong) NSString *version;
/**  */
@property (nonatomic, strong) NSString *currency;
/**  */
@property (nonatomic, strong) NSString *sign;
/**  */
@property (nonatomic, strong) NSString *amount;
/**  */
@property (nonatomic, strong) NSString *notifyUrl;
/**  */
@property (nonatomic, strong) NSString *merchant;
/**  */
@property (nonatomic, strong) NSString *url;
/**  */
@property (nonatomic, strong) NSString *device;
/**  */
@property (nonatomic, strong) NSString *note;
/**  */
@property (nonatomic, strong) NSString *ip;
/**  */
@property (nonatomic, strong) NSString *userType;
/**  */
@property (nonatomic, strong) NSString *userId;
/**  */
@property (nonatomic, strong) NSString *expireTime;

/**  */
@property (nonatomic, strong) NSString *orderType;
/**  */
@property (nonatomic, strong) NSString *industryCategoryCode;
/**  */
@property (nonatomic, strong) NSString *specCardNo;
/**  */
@property (nonatomic, strong) NSString *specId;
/**  */
@property (nonatomic, strong) NSString *specName;

@end
