//
//  EditViewController.m
//  Fiu
//
//  Created by FLYang on 16/6/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "EditViewController.h"

static NSString *const URLReleaseScenen = @"/scene_sight/save";
static NSString *const URLReleaseFiuScenen = @"/scene_scene/save";

@interface EditViewController ()

@end

@implementation EditViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavViewUI];
    
    //  from: "SelectAllFSceneViewController.h"
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFSceneId:) name:@"selectFiuSceneId" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFSceneTitle:) name:@"selectFiuSceneTitle" object:nil];
}

- (void)getFSceneId:(NSNotification *)fsceneId {
    self.fSceneId = [fsceneId object];
}

- (void)getFSceneTitle:(NSNotification *)fsceneTitle {
    self.fSceneTitle = [fsceneTitle object];
    if (self.fSceneTitle.length > 0) {
        [self.addCategory getChooseFScene:self.fSceneTitle];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.data);
    [self setReleaseViewUI];
}

#pragma mark - 网络请求
#pragma mark 编辑情景
- (void)networkNewSceneData {
    NSString * title = [self.addContent.title.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * des = [self.addContent.content.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * tags =  [self.addContent.chooseTagMarr componentsJoinedByString:@","];
    NSString * sceneId = [NSString stringWithFormat:@"%zi", [[self.data valueForKey:@"_id"] integerValue]];
    
    if ([self.addLocaiton.longitude length] <= 0 || [title isEqualToString:@""] || [des isEqualToString:NSLocalizedString(@"addDescription", nil)] || [des isEqualToString:@""] || [self.addLocaiton.locationLab.text isEqualToString:@""] || tags.length <=0) {
        [SVProgressHUD showInfoWithStatus:@"填写未完成"];
        
    } else if (title.length > 20) {
        [SVProgressHUD showInfoWithStatus:@"请输入20字以内的标题"];
        
    } else {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        
        NSDictionary * paramDict = @{
                                     @"id":sceneId,
                                     @"title":title,
                                     @"des":des,
                                     @"lng":self.addLocaiton.longitude,
                                     @"lat":self.addLocaiton.latitude,
                                     @"address":self.addLocaiton.locationLab.text,
                                     @"tags":tags,
                                     @"scene_id":self.fSceneId
                                     };
        
        self.editSceneRequest = [FBAPI postWithUrlString:URLReleaseScenen requestDictionary:paramDict delegate:self];
        
        [self.editSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
            [self dismissViewControllerAnimated:YES completion:^{
                self.editSceneDone();
            }];
            
        } failure:^(FBRequest *request, NSError *error) {
            NSLog(@"%@", error);
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];
    }
}

#pragma mark 编辑地盘
//- (void)networkNewFiuSceneData {
//    NSString * title = [self.scenceView.title.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSString * des = [self.scenceView.content.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//    
//    if ([self.lng length] <= 0 || [title isEqualToString:@""] || [des isEqualToString:NSLocalizedString(@"addFiuSceneDes", nil)] || [des isEqualToString:@""] || [self.addView.location.text isEqualToString:@""] || self.tagS.length <=0) {
//        [SVProgressHUD showInfoWithStatus:@"填写未完成"];
//    } else if (title.length > 20) {
//        [SVProgressHUD showInfoWithStatus:@"请输入20字以内的标题"];
//        
//    } else if (des.length > 140) {
//        [SVProgressHUD showInfoWithStatus:@"请输入140字以内的描述"];
//        
//    } else {
//        NSDictionary * paramDict = @{
//                                     @"id":self.ids,
//                                     @"title":title,
//                                     @"des":des,
//                                     @"lng":self.lng,
//                                     @"lat":self.lat,
//                                     @"address":self.addView.location.text,
//                                     @"tags":self.tagS,
//                                     };
//        self.editSceneRequest = [FBAPI postWithUrlString:URLReleaseFiuScenen requestDictionary:paramDict delegate:self];
//        
//        [self.editSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
//            [self dismissViewControllerAnimated:YES completion:^{
//                self.editSceneDone();
//            }];
//            
//        } failure:^(FBRequest *request, NSError *error) {
//            NSLog(@"%@", error);
//            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
//        }];
//    }
//}

#pragma mark - 设置视图UI
- (void)setReleaseViewUI {
    [self.view addSubview:self.bgImgView];
    [self.view bringSubviewToFront:self.navView];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.addContentBtn];
    [self.view addSubview:self.addContent];
}

#pragma mark - 情景背景图片
- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgImgView.image = self.bgImg;
        _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImgView.clipsToBounds = YES;
        
        UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        effectView.frame = _bgImgView.bounds;
        effectView.alpha = 1.0f;
        [_bgImgView addSubview:effectView];
    }
    return _bgImgView;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 88)];
        
        [_topView addSubview:self.addLocaiton];
        [_topView addSubview:self.addCategory];
    }
    return _topView;
}

#pragma mark - 添加地点
- (AddLocationView *)addLocaiton {
    if (!_addLocaiton) {
        _addLocaiton = [[AddLocationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _addLocaiton.vc = self;
        _addLocaiton.addLocation.hidden = YES;
        _addLocaiton.clearBtn.hidden = NO;
        _addLocaiton.locationView.hidden = NO;
        _addLocaiton.locationLab.text = [self.data valueForKey:@"address"];
        _addLocaiton.cityLab.text = [self.data valueForKey:@"city"];
        _addLocaiton.longitude = [NSString stringWithFormat:@"%@", [[self.data valueForKey:@"location"] valueForKey:@"coordinates"][0]];
        _addLocaiton.latitude = [NSString stringWithFormat:@"%@", [[self.data valueForKey:@"location"] valueForKey:@"coordinates"][1]];
    }
    return _addLocaiton;
}

#pragma mark - 添加分类
- (AddCategoryView *)addCategory {
    if (!_addCategory) {
        _addCategory = [[AddCategoryView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 44)];
        _addCategory.vc = self;
        [_addCategory.addCategory setTitle:[self.data valueForKey:@"scene_title"] forState:(UIControlStateNormal)];
    }
    return _addCategory;
}

#pragma mark - 添加内容按钮
- (UIButton *)addContentBtn {
    if (!_addContentBtn) {
        _addContentBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, SCREEN_HEIGHT - 100, SCREEN_WIDTH - 15, 44)];
        [_addContentBtn setTitle:NSLocalizedString(@"addContent", nil) forState:(UIControlStateNormal)];
        _addContentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_addContentBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:0.8] forState:(UIControlStateNormal)];
        _addContentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_addContentBtn addTarget:self action:@selector(addContentBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        _addContentBtn.hidden = YES;
        
        UILabel * lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH - 15, 1)];
        lineLab.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.3];
        [_addContentBtn addSubview:lineLab];
    }
    return _addContentBtn;
}

#pragma mark - 改变视图位置，弹出内容输入框
- (void)addContentBtnClick {
    CGRect topRect = CGRectMake(0, -100, SCREEN_WIDTH, 88);
    [UIView animateWithDuration:.3 animations:^{
        self.navView.alpha = 0;
        self.topView.frame = topRect;
        self.addContentBtn.alpha = 0;
    }];
    
    CGRect contentRect = CGRectMake(0, SCREEN_HEIGHT - 530, SCREEN_WIDTH, 280);
    [UIView animateWithDuration:0.3 animations:^{
        self.addContent.alpha = 1;
        self.addContent.frame = contentRect;
        self.addContent.chooseText.hidden = NO;
        [self.addContent.title becomeFirstResponder];
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * view in self.view.subviews) {
        if ([view isKindOfClass:[self.bgImgView class]]) {
            [self editDone];
        }
    }
}

#pragma mark - 点击空白处，编辑完成
- (void)editDone {
    if (self.addContent.title.text.length > 0 && ![self.addContent.content.text isEqualToString:NSLocalizedString(@"addDescription", nil)]) {
        CGRect topRect = CGRectMake(0, 50, SCREEN_WIDTH, 88);
        [UIView animateWithDuration:.3 animations:^{
            self.navView.alpha = 1;
            self.topView.frame = topRect;
        }];
        
        CGRect contentRect = CGRectMake(0, SCREEN_HEIGHT - 230, SCREEN_WIDTH, 280);
        [UIView animateWithDuration:0.3 animations:^{
            self.addContent.alpha = 1;
            self.addContent.frame = contentRect;
            self.addContent.chooseText.hidden = YES;
            [self.addContent.title resignFirstResponder];
        }];
        [self.addContent.title resignFirstResponder];
        [self.addContent.content resignFirstResponder];
        
        if (self.addContent.chooseTagMarr.count > 0) {
            [self.addContent getUserEditTags:self.addContent.chooseTagMarr];
        }
        
    } else {
        self.addContentBtn.hidden = NO;
        
        CGRect topRect = CGRectMake(0, 50, SCREEN_WIDTH, 88);
        [UIView animateWithDuration:.3 animations:^{
            self.navView.alpha = 1;
            self.topView.frame = topRect;
            self.addContentBtn.alpha = 1;
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.addContent.alpha = 0;
            [self.addContent.title resignFirstResponder];
        }];
    }
}

#pragma mark - 内容视图
- (AddContentView *)addContent {
    if (!_addContent) {
        _addContent = [[AddContentView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 230, SCREEN_WIDTH, 280)];
        _addContent.vc = self;
        _addContent.delegate = self;
        _addContent.chooseText.hidden = YES;
        _addContent.title.text = [self.data valueForKey:@"title"];
        _addContent.content.text = [self.data valueForKey:@"des"];
        [_addContent getUserEditTags:[NSMutableArray arrayWithArray:[self.data valueForKey:@"tags"]]];
    }
    return _addContent;
}

- (void)EditBegin {
    [self addContentBtnClick];
}

#pragma mark -  设置导航栏
- (void)setNavViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0];
    [self addNavViewTitle:NSLocalizedString(@"editScene", nil)];
    self.navTitle.textColor = [UIColor whiteColor];
    [self.closeBtn setImage:[UIImage imageNamed:@"icon_cancel"] forState:(UIControlStateNormal)];
    [self addCloseBtn];
    [self addDoneButton];
    self.line.backgroundColor = [UIColor colorWithHexString:lineGrayColor alpha:0.3];
    [self addLine];
    [self.doneBtn addTarget:self action:@selector(releaseScene) forControlEvents:(UIControlEventTouchUpInside)];
}

#pragma mark - 确认修改
- (void)releaseScene {
    if ([self.createType isEqualToString:@"scene"]) {
        [self networkNewSceneData];
        
    }
//    else if ([self.createType isEqualToString:@"fScene"]) {
//        [self networkNewFiuSceneData];
//    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"a" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectFiuSceneId" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectFiuSceneTitle" object:nil];
}

@end
