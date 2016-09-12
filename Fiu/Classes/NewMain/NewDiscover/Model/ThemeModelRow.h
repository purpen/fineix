#import <UIKit/UIKit.h>

@interface ThemeModelRow : NSObject

@property (nonatomic, strong) NSString * idField;
@property (nonatomic, assign) NSInteger assetType;
@property (nonatomic, strong) NSObject * attendCount;
@property (nonatomic, strong) NSString * beginTimeAt;
@property (nonatomic, strong) NSString * cid;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * coverId;
@property (nonatomic, strong) NSString * coverUrl;
@property (nonatomic, strong) NSString * createdOn;
@property (nonatomic, strong) NSString * endTimeAt;
@property (nonatomic, strong) NSString * highContent;
@property (nonatomic, strong) NSString * highTitle;
@property (nonatomic, strong) NSString * kind;
@property (nonatomic, strong) NSString * kindName;
@property (nonatomic, strong) NSString * oid;
@property (nonatomic, strong) NSString * pid;
@property (nonatomic, strong) NSString * shortTitle;
@property (nonatomic, strong) NSArray * tags;
@property (nonatomic, strong) NSObject * tid;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString * updatedOn;
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, assign) NSInteger viewCount;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end