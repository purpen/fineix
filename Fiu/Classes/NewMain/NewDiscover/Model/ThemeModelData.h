#import <UIKit/UIKit.h>
#import "ThemeModelRow.h"

@interface ThemeModelData : NSObject

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger currentUserId;
@property (nonatomic, strong) NSString * msg;
@property (nonatomic, strong) NSArray * rows;
@property (nonatomic, assign) BOOL success;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) NSInteger totalPage;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end