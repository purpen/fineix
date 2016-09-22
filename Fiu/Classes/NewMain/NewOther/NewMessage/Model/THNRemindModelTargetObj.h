#import <UIKit/UIKit.h>

@interface THNRemindModelTargetObj : NSObject

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * coverUrl;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
