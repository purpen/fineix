#import <UIKit/UIKit.h>

@interface THNRemindModelTarget : NSObject

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * content;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end