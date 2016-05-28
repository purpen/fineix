//
//  FBTabBar.m
//  fineix
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBTabBar.h"
#import "UserInfoEntity.h"
#import "CounterModel.h"
#import "NSObject+MJKeyValue.h"

@implementation FBTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = CGRectMake(0, SCREEN_HEIGHT - 59.5, SCREEN_WIDTH, 59.5);
        //  设置tabBar边框顶部黑线跟背景颜色
        CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, .5f);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:@"#E1E1E1" alpha:.1].CGColor);
        CGContextFillRect(context, rect);
        UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if (SCREEN_WIDTH <= 320) {
            self.backgroundImage = [UIImage imageNamed:@"tabBar_5"];
        } else {
            self.backgroundImage = [UIImage imageNamed:@"tabBar"];
        }
        self.shadowImage = img;
        self.translucent = YES;
        
        [self addSubview:self.badgeView];
    }
    return self;
}


#pragma mark - 自定义的“创建”按钮
- (UIButton *)createBtn {
    if (!_createBtn) {
        _createBtn = [[UIButton alloc] init];
        _createBtn.backgroundColor = [UIColor whiteColor];
        [_createBtn setImage:[UIImage imageNamed:@"Create"] forState:(UIControlStateNormal)];
        [_createBtn setImage:[UIImage imageNamed:@"Create"] forState:(UIControlStateHighlighted)];
        [_createBtn sizeToFit];
    }
    return _createBtn;
}

#pragma mark - 自定义按钮标题“Fiu”
- (UILabel *)createTitle {
    if (!_createTitle) {
        _createTitle = [[UILabel alloc] init];
        _createTitle.text = @"Fiu";
        _createTitle.textColor = [UIColor colorWithHexString:tabBarTitle alpha:1];
        _createTitle.font = [UIFont systemFontOfSize:11.5];
        _createTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _createTitle;
}

-(void)chang{
    self.badgeView.backgroundColor = [UIColor whiteColor];
}

-(UIView *)badgeView{
    if (!_badgeView) {
        _badgeView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 35/667.0*SCREEN_HEIGHT, 5/667.0*SCREEN_HEIGHT, 8, 8)];
        //请求数据看看有没有通知的消息--------------------------
        UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
        FBRequest *requestMsg = [FBAPI postWithUrlString:@"/auth/user" requestDictionary:@{@"user_id":entity.userId} delegate:self];
        [requestMsg startRequestSuccess:^(FBRequest *request, id result) {
            NSDictionary *dataDict = result[@"data"];
            NSDictionary *counterDict = [dataDict objectForKey:@"counter"];
            CounterModel *counterModel = [CounterModel mj_objectWithKeyValues:counterDict];
            if (counterModel.order_total_count!=0 || counterModel.message_total_count!=0) {
                //                UITabBarItem * item=[tabBarC.tabBar.items objectAtIndex:3];
                //                item.badgeValue=@"";
                //显示
                _badgeView.backgroundColor = [UIColor colorWithHexString:fineixColor];
            }else{
                _badgeView.backgroundColor = [UIColor whiteColor];
            }
        } failure:^(FBRequest *request, NSError *error) {
        }];
        _badgeView.layer.masksToBounds = YES;
        _badgeView.layer.cornerRadius = 4;
//        _badgeView.layer.shouldRasterize = YES;
    }
    return _badgeView;
}

#pragma mark - 调整tabBar上item的位置和尺寸
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self addSubview:self.createBtn];
    [self addSubview:self.createTitle];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGFloat btnX = 0;
    CGFloat btnY = 0;
    CGFloat btnW = width / (self.items.count + 1);
    CGFloat btnH = height;
    
    NSUInteger idx = 0;
    for (UIView * tabBarButton in self.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            if (idx == 2) {
                idx = 3;
            }
            btnX = idx * btnW;
            tabBarButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
            idx++;
        }
    }
    //  设置自定义的按钮在中间
    self.createBtn.frame = CGRectMake(btnX, btnY, 49, 49);
    self.createBtn.layer.cornerRadius = 49 / 2;
    self.createBtn.center = CGPointMake(width * 0.5, height * 0.3);
    
    //  标题
    self.createTitle.frame = CGRectMake(btnX, btnY, 60, 12);
    self.createTitle.center = CGPointMake(width * 0.5, height * 0.87);
    
}


@end
