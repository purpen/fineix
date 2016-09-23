#import <UIKit/UIKit.h>
#import "THNUserModelData.h"

@interface THNUserModel : NSObject

@property (nonatomic, assign) NSInteger currentUserId;
@property (nonatomic, strong) THNUserModelData * data;
@property (nonatomic, assign) BOOL isError;
@property (nonatomic, strong) NSString * message;
@property (nonatomic, strong) NSString * status;
@property (nonatomic, assign) BOOL success;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end