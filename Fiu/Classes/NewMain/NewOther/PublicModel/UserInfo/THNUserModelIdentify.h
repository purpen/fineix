#import <UIKit/UIKit.h>

@interface THNUserModelIdentify : NSObject

@property (nonatomic, assign) NSInteger isExpert;
@property (nonatomic, assign) NSInteger isSceneSubscribe;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end