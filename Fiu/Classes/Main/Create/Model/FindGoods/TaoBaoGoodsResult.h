//
//	TaoBaoGoodsResult.h
// on 4/5/2016
//	Copyright © 2016. All rights reserved.
//

//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

#import <UIKit/UIKit.h>
#import "TaoBaoGoodsNTbkItem.h"

@interface TaoBaoGoodsResult : NSObject

@property (nonatomic, strong) NSArray * nTbkItem;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end