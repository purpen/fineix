//
//	MarkGoods.h
// on 12/5/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "MarkGoodsData.h"

@interface MarkGoods : NSObject

@property (nonatomic, assign) NSInteger currentUserId;
@property (nonatomic, strong) MarkGoodsData * data;
@property (nonatomic, assign) BOOL isError;
@property (nonatomic, strong) NSString * message;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, assign) BOOL success;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end