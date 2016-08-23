#import <UIKit/UIKit.h>
#import "THNMallGoodsModelItem.h"

@interface THNMallGoodsModelData : NSObject

@property (nonatomic, assign) NSInteger currentUserId;
@property (nonatomic, strong) NSArray * items;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end