#import <UIKit/UIKit.h>

@interface THNRemindModelSUser : NSObject

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * avatarUrl;
@property (nonatomic, strong) NSString * nickname;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
