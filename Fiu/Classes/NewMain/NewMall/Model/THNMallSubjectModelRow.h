#import <UIKit/UIKit.h>
#import "THNMallSubjectModelProduct.h"

@interface THNMallSubjectModelRow : NSObject

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, strong) NSObject * attendCount;
@property (nonatomic, strong) NSString * bannerId;
@property (nonatomic, assign) BOOL beginTime;
@property (nonatomic, strong) NSString * beginTimeAt;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, strong) NSString * coverId;
@property (nonatomic, strong) NSString * coverUrl;
@property (nonatomic, assign) BOOL endTime;
@property (nonatomic, strong) NSString * endTimeAt;
@property (nonatomic, assign) NSInteger evt;
@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, assign) NSInteger fine;
@property (nonatomic, assign) NSInteger fineOn;
@property (nonatomic, assign) NSInteger kind;
@property (nonatomic, assign) NSInteger loveCount;
@property (nonatomic, strong) NSArray * productIds;
@property (nonatomic, strong) NSArray * products;
@property (nonatomic, assign) NSInteger publish;
@property (nonatomic, strong) NSObject * shareCount;
@property (nonatomic, strong) NSString * shortTitle;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger stick;
@property (nonatomic, strong) NSObject * stickOn;
@property (nonatomic, strong) NSString * summary;
@property (nonatomic, strong) NSArray * tags;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger viewCount;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end