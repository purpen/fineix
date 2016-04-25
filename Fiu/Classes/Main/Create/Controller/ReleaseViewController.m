//
//  ReleaseViewController.m
//  fineix
//
//  Created by FLYang on 16/3/2.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ReleaseViewController.h"
#import "CreateViewController.h"

static NSString *const URLReleaseScenen = @"/scene_sight/save";

@interface ReleaseViewController ()

@end

@implementation ReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavViewUI];
    
    [self setReleaseViewUI];

}

#pragma mark - 网络请求
- (void)networkRequestData {
    [SVProgressHUD show];
    NSData * imageData = UIImageJPEGRepresentation(self.scenceView.imageView.image, 0.5);
    NSString * icon64Str = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSDictionary * paramDict = @{
                            @"tmp":icon64Str,
                            @"title":self.scenceView.title.text,
                            @"des":self.scenceView.content.text,
                            @"lng":self.lng,
                            @"lat":self.lat,
                            @"address":self.addView.location.text,
                            @"product_id":@"1,2,3",
                            @"product_title":@"a,b,c",
                            @"product_price":@"12,20,30",
                            @"product_x":@"20,30,40",
                            @"product_y":@"30,40,50",
                            @"tags":@"1,2,3",
                            @"scene_id":@"5",
                            };
    self.releaseSceneRequest = [FBAPI postWithUrlString:URLReleaseScenen requestDictionary:paramDict delegate:self];
    [self.releaseSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝  发布成功：%@", result);
        [SVProgressHUD dismiss];
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝  发布失败：%@", error);
    }];
//    NSLog(@"－－－－－－－－－－－－－－－－－－－－－－－－ 发布信息：%@", paramDict);
}

#pragma mark - 设置视图UI
- (void)setReleaseViewUI {
    [self.view addSubview:self.scenceView];
    
    [self.view addSubview:self.addView];

}

#pragma mark - 添加文字信息的视图
- (ScenceMessageView *)scenceView {
    if (!_scenceView) {
        _scenceView = [[ScenceMessageView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 236.5)];
    }
    return _scenceView;
}

#pragma mark - 添加位置／标签／所属情景的视图
- (ScenceAddMoreView *)addView {
    if (!_addView) {
        _addView = [[ScenceAddMoreView alloc] initWithFrame:CGRectMake(0, 290, SCREEN_WIDTH, SCREEN_HEIGHT- 290)];
        _addView.nav = self.navigationController;
        
        if ([self.locationArr[0] isEqualToString:@"0.000000"]) {
            NSLog(@"照片上没有位置信息");
        } else {
            NSLog(@"＝＝＝＝＝＝＝  经纬度 ：%@", self.locationArr);
            [_addView changeLocationFrame:self.locationArr];
            self.lng = self.locationArr[0];
            self.lat = self.locationArr[1];
        }
    }
    return _addView;
}

#pragma mark -  设置导航栏
- (void)setNavViewUI {
    self.navView.backgroundColor = [UIColor whiteColor];
    [self addNavViewTitle:NSLocalizedString(@"releaseVcTitle", nil)];
    self.navTitle.textColor = [UIColor blackColor];
    [self addCancelDoneButton];
    [self addDoneButton];
    [self addLine];
    [self.doneBtn addTarget:self action:@selector(releaseScene) forControlEvents:(UIControlEventTouchUpInside)];
}

#pragma mark - 确认发布场景
- (void)releaseScene {
    [self networkRequestData];
}

@end
