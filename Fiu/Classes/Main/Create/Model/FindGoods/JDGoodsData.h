//
//	JDGoodsData.h
// on 10/5/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "JDGoodsListproductbaseResult.h"

@interface JDGoodsData : NSObject

@property (nonatomic, strong) NSString * code;
@property (nonatomic, assign) NSInteger currentUserId;
@property (nonatomic, strong) NSArray * listproductbaseResult;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end