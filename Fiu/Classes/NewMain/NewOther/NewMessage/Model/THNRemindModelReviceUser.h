#import <UIKit/UIKit.h>

@interface THNRemindModelReviceUser : NSObject

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSString * avatarUrl;
@property (nonatomic, strong) NSString * nickname;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end