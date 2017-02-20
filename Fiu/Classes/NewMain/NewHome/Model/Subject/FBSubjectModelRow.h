#import <UIKit/UIKit.h>

@interface FBSubjectModelRow : NSObject

@property (nonatomic, assign) NSInteger idField;
@property (nonatomic, assign) NSInteger attendCount;
@property (nonatomic, strong) NSString * bannerId;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, strong) NSString * coverId;
@property (nonatomic, strong) NSString * coverUrl;
@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, assign) NSInteger fine;
@property (nonatomic, assign) NSInteger fineOn;
@property (nonatomic, assign) NSInteger kind;
@property (nonatomic, assign) NSInteger loveCount;
@property (nonatomic, assign) NSInteger publish;
@property (nonatomic, assign) NSInteger shareCount;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger stick;
@property (nonatomic, assign) NSInteger stickOn;
@property (nonatomic, strong) NSString * summary;
@property (nonatomic, strong) NSArray * tags;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger viewCount;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
