#import <UIKit/UIKit.h>

@interface THNMallGoodsModelItem : NSObject

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) CGFloat salePrice;
@property (nonatomic, strong) NSString * brandCoverUrl;
@property (nonatomic, strong) NSString * brandId;
@property (nonatomic, strong) NSString * coverUrl;
@property (nonatomic, strong) NSString * title;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
