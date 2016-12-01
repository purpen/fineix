#import <UIKit/UIKit.h>

@interface FBGoodsInfoModelSku : NSObject

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger badCount;
@property (nonatomic, strong) NSString * badTag;
@property (nonatomic, assign) NSInteger createdOn;
@property (nonatomic, assign) NSInteger limitedCount;
@property (nonatomic, strong) NSString * mode;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, assign) NSInteger revokeCount;
@property (nonatomic, assign) NSInteger shelf;
@property (nonatomic, assign) NSInteger sold;
@property (nonatomic, assign) NSInteger stage;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * summary;
@property (nonatomic, assign) NSInteger syncCount;
@property (nonatomic, assign) NSInteger updatedOn;
@property (nonatomic, strong) NSString *coverUrl;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
