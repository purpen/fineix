#import <UIKit/UIKit.h>
#import "THNMallGoodsModelData.h"

@interface THNMallGoodsModel : NSObject

@property (nonatomic, assign) NSInteger currentUserId;
@property (nonatomic, strong) THNMallGoodsModelData * data;
@property (nonatomic, assign) BOOL isError;
@property (nonatomic, strong) NSString * message;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, assign) BOOL success;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end