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
static NSString *const URLReleaseFiuScenen = @"/scene_scene/save";

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
#pragma mark 发布场景
- (void)networkNewSceneData {
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
                            @"product_id":self.goodsId,
                            @"product_title":self.goodsTitle,
                            @"product_price":self.goodsPrice,
                            @"product_x":self.goodsX,
                            @"product_y":self.goodsY,
                            @"tags":self.tagS,
                            @"scene_id":self.fSceneId,
                            };
    self.releaseSceneRequest = [FBAPI postWithUrlString:URLReleaseScenen requestDictionary:paramDict delegate:self];
    
    [self.releaseSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝  发布成功：%@", result);
        [SVProgressHUD showSuccessWithStatus:@"发布成功"];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        NSLog(@"＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝  发布失败：%@", error);
    }];
}

#pragma mark 发布情景
- (void)networkNewFiuSceneData {
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
                                 @"tags":self.tagS,
                                 };
    self.releaseSceneRequest = [FBAPI postWithUrlString:URLReleaseFiuScenen requestDictionary:paramDict delegate:self];
    
    [self.releaseSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝  发布成功：%@", result);
        [self dismissViewControllerAnimated:YES completion:nil];
        [SVProgressHUD showSuccessWithStatus:@"发布成功"];
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        NSLog(@"＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝  发布失败：%@", error);
    }];
    
}

#pragma mark - 设置视图UI
- (void)setReleaseViewUI {
    if ([self.createType isEqualToString:@"scene"]) {
        self.addView.addScene.hidden = NO;
    } else if ([self.createType isEqualToString:@"fScene"]) {
        self.addView.addScene.hidden = YES;
    }
    [self.view addSubview:self.scenceView];
    
    [self.view addSubview:self.addView];
    
    //  add #import "ScenceAddMoreView.h"
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationArr:) name:@"locationArr" object:nil];

}

- (void)locationArr:(NSNotification *)locationArr {
    self.lat = [locationArr object][0];
    self.lng = [locationArr object][1];
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
    
    if ([self.createType isEqualToString:@"scene"]) {
        [self addNavViewTitle:NSLocalizedString(@"releaseVcTitle", nil)];
    } else if ([self.createType isEqualToString:@"fScene"]) {
        [self addNavViewTitle:NSLocalizedString(@"freleaseVcTitle", nil)];
    }

    self.navTitle.textColor = [UIColor blackColor];
    [self addCancelDoneButton];
    [self addDoneButton];
    [self addLine];
    [self.doneBtn addTarget:self action:@selector(releaseScene) forControlEvents:(UIControlEventTouchUpInside)];
}

#pragma mark - 确认发布场景
- (void)releaseScene {
    if ([self.createType isEqualToString:@"scene"]) {
        [self networkNewSceneData];
    } else if ([self.createType isEqualToString:@"fScene"]) {
        [self networkNewFiuSceneData];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"locationArr" object:nil];
}

@end
