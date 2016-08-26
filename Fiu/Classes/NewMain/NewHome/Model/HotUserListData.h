#import <UIKit/UIKit.h>
#import "HotUserListUser.h"

@interface HotUserListData : NSObject

@property (nonatomic, assign) NSInteger currentUserId;
@property (nonatomic, strong) NSArray * users;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end