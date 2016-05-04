//
//	TaoBaoGoodsData.h
// on 4/5/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "TaoBaoGoodsResult.h"

@interface TaoBaoGoodsData : NSObject

@property (nonatomic, assign) NSInteger currentUserId;
@property (nonatomic, strong) NSString * requestId;
@property (nonatomic, strong) TaoBaoGoodsResult * results;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end