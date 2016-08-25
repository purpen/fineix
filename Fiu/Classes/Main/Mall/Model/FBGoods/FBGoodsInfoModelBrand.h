#import <UIKit/UIKit.h>

@interface FBGoodsInfoModelBrand : NSObject

@property (nonatomic, strong) NSString * idField;
@property (nonatomic, strong) NSString * coverUrl;
@property (nonatomic, strong) NSString * title;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end