#import <UIKit/UIKit.h>
#import "FBGoodsInfoModelData.h"

@interface FBGoodsInfoModel : NSObject

@property (nonatomic, assign) NSInteger currentUserId;
@property (nonatomic, strong) FBGoodsInfoModelData * data;
@property (nonatomic, assign) BOOL isError;
@property (nonatomic, strong) NSString * message;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, assign) BOOL success;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end