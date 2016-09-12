#import <UIKit/UIKit.h>

@interface THNMallSubjectModelProduct : NSObject

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * bannerUrl;
@property (nonatomic, strong) NSString * summary;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger salePrice;
@property (nonatomic, strong) NSString * coverUrl;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end