//
//  ReleaseViewController.m
//  fineix
//
//  Created by FLYang on 16/3/2.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ReleaseViewController.h"
#import "CreateViewController.h"
#import "HomeViewController.h"
#import "LookSceneViewController.h"
#import "IQKeyboardManager.h"

static NSString *const URLReleaseScenen = @"/scene_sight/save";
static NSString *const URLReleaseFiuScenen = @"/scene_scene/save";
static NSString *const URLGetUserDesTags = @"/gateway/fetch_chinese_word";

@interface ReleaseViewController () {

}

@end

@implementation ReleaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFSceneId:) name:@"selectFiuSceneId" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFSceneTitle:) name:@"selectFiuSceneTitle" object:nil];

    [self setNavViewUI];
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
    
    [self setReleaseViewUI];
}

#pragma mark - 网络请求
#pragma mark 获取用户填写描述的标签
- (void)networkGetUserDesTags:(NSString *)title withDes:(NSString *)des {
    self.getUserDesTagsRequest = [FBAPI postWithUrlString:URLGetUserDesTags requestDictionary:@{@"title":title, @"content":des} delegate:self];
    [self.getUserDesTagsRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * tagsArr = [[result valueForKey:@"data"] valueForKey:@"word"];
        NSMutableArray * tagsMarr = [NSMutableArray array];
        if (tagsArr.count > 10) {
            for (NSUInteger idx = 0; idx < 10; ++ idx) {
                [tagsMarr addObject:tagsArr[idx]];
            }
        } else {
            tagsMarr = [NSMutableArray arrayWithArray:tagsArr];
        }
        
        if (self.addContent.chooseTagMarr.count > 0) {
            [self.addContent getUserEditTags:self.addContent.chooseTagMarr];
            
        } else {
            if (tagsMarr.count > 0) {
                [self.addContent getUserEditTags:tagsMarr];
            }
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark 发布场景
- (void)networkNewSceneData {
    NSString * title = [self.showContent.titleText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * des = [self.showContent.desText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString * tags =  [self.showContent.chooseTagMarr componentsJoinedByString:@","];

    if ([self.addLocaiton.longitude length] <= 0 || [title isEqualToString:@""] || [des isEqualToString:NSLocalizedString(@"addDescription", nil)] || [des isEqualToString:@""] || [self.addLocaiton.locationLab.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"填写未完成"];

    } else if (title.length > 20) {
        [SVProgressHUD showInfoWithStatus:@"请输入20字以内的标题"];
        
    } else {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        NSMutableArray * goodsMarr = [NSMutableArray array];
        for (NSUInteger idx = 0; idx < self.goodsId.count; ++ idx) {
            NSDictionary *  goodsDict = @{@"id":self.goodsId[idx],
                                          @"price":self.goodsPrice[idx],
                                          @"title":self.goodsTitle[idx],
                                          @"x":self.goodsX[idx],
                                          @"y":self.goodsY[idx]};
            [goodsMarr addObject:goodsDict];
        }
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:goodsMarr options:0 error:nil];
        NSString * json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSData * imageData = UIImageJPEGRepresentation(self.bgImg, 0.7);
        NSString * icon64Str = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSDictionary * paramDict = @{
                                     @"tmp":icon64Str,
                                     @"title":title,
                                     @"des":des,
                                     @"lng":self.addLocaiton.longitude,
                                     @"lat":self.addLocaiton.latitude,
                                     @"address":self.addLocaiton.locationLab.text,
                                     @"city":self.addLocaiton.cityLab.text,
                                     @"products":json,
                                     @"tags":tags,
                                     @"scene_id":self.fSceneId
                                     };
        
        self.releaseSceneRequest = [FBAPI postWithUrlString:URLReleaseScenen requestDictionary:paramDict delegate:self];
        
        [self.releaseSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
            NSString * sceneId = [NSString stringWithFormat:@"%@",[[result valueForKey:@"data"] valueForKey:@"id"]];
            LookSceneViewController * sceneInfoVC = [[LookSceneViewController alloc] init];
            sceneInfoVC.sceneId = sceneId;
            [self.navigationController pushViewController:sceneInfoVC animated:YES];
            [SVProgressHUD dismiss];

        } failure:^(FBRequest *request, NSError *error) {
            NSLog(@"%@", error);
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];
    }
}

#pragma mark - 设置视图UI
- (void)setReleaseViewUI {
    [self.view addSubview:self.bgImgView];
    [self.view bringSubviewToFront:self.navView];
    
    [self.view addSubview:self.topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 88));
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-20);
    }];
    
    [self.view addSubview:self.addContentBtn];
    [_addContentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 30));
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.bottom.equalTo(_topView.mas_top).with.offset(-8);
    }];
    
    [self.view addSubview:self.addContent];
    
    [self.view addSubview:self.addTagsView];
}

#pragma mark - 情景背景图片
- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgImgView.image = self.bgImg;
        _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImgView.clipsToBounds = YES;
        
        //  添加渐变层
        CAGradientLayer * shadow = [CAGradientLayer layer];
        shadow.startPoint = CGPointMake(0, 0);
        shadow.endPoint = CGPointMake(0, 1);
        shadow.colors = @[(__bridge id)[UIColor clearColor].CGColor,
                          (__bridge id)[UIColor blackColor].CGColor];
        shadow.locations = @[@(0.5f), @(1.5f)];
        shadow.frame = _bgImgView.bounds;
        [_bgImgView.layer addSublayer:shadow];
        
        CAGradientLayer * topShadow = [CAGradientLayer layer];
        topShadow.startPoint = CGPointMake(0, 1);
        topShadow.endPoint = CGPointMake(0, 0);
        topShadow.colors = @[(__bridge id)[UIColor clearColor].CGColor,
                          (__bridge id)[UIColor blackColor].CGColor];
        topShadow.locations = @[@(0.5f), @(1.5f)];
        topShadow.frame = _bgImgView.bounds;
        [_bgImgView.layer addSublayer:topShadow];
    }
    return _bgImgView;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        
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
    }
    return _addLocaiton;
}

#pragma mark - 添加分类
- (AddCategoryView *)addCategory {
    if (!_addCategory) {
        _addCategory = [[AddCategoryView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 44)];
        _addCategory.vc = self;
    }
    return _addCategory;
}

#pragma mark - 添加内容按钮
- (UIButton *)addContentBtn {
    if (!_addContentBtn) {
        _addContentBtn = [[UIButton alloc] init];
        [_addContentBtn setTitle:NSLocalizedString(@"addContent", nil) forState:(UIControlStateNormal)];
        if (IS_iOS9) {
            _addContentBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:21];
        } else {
            _addContentBtn.titleLabel.font = [UIFont systemFontOfSize:21];
        }
        [_addContentBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] forState:(UIControlStateNormal)];
        _addContentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_addContentBtn addTarget:self action:@selector(addContentBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        
        NSMutableAttributedString * titleText = [[NSMutableAttributedString alloc] initWithString:_addContentBtn.titleLabel.text];
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentJustified;
        
        NSDictionary * textDict = @{
                                    NSBackgroundColorAttributeName:[UIColor colorWithPatternImage:[UIImage imageNamed:@"addTitleBtnBg"]] ,
                                    NSParagraphStyleAttributeName :paragraphStyle
                                    };
        [titleText addAttributes:textDict range:NSMakeRange(0, titleText.length)];
        _addContentBtn.titleLabel.attributedText = titleText;
    }
    return _addContentBtn;
}

#pragma mark - 改变视图位置，弹出内容输入框
- (void)addContentBtnClick {
    [UIView animateWithDuration:.3 animations:^{
        self.addContent.alpha = 1;
        [self.addContent.title becomeFirstResponder];
    }];
    
    __weak __typeof(self)weakSelf = self;
    self.addContent.getEditContentAndTags = ^ (NSString * title, NSString * des, NSMutableArray * tags){
        if (title.length > 0) {
            weakSelf.addContentBtn.hidden = YES;
            [weakSelf.view addSubview:weakSelf.showContent];
            [weakSelf.showContent mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(SCREEN_WIDTH));
                make.left.equalTo(weakSelf.view.mas_left).with.offset(0);
                make.bottom.equalTo(weakSelf.topView.mas_top).with.offset(0);
                make.top.equalTo(weakSelf.view.mas_top).with.offset(100);
            }];
            [weakSelf.showContent setEditContentData:title withDes:des withTags:tags];
        
        } else {
            weakSelf.addContentBtn.hidden = NO;
        }
    };
}

#pragma mark - 添加内容视图
- (AddContentView *)addContent {
    if (!_addContent) {
        _addContent = [[AddContentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _addContent.vc = self;
        _addContent.bgImage = self.bgImg;
        _addContent.alpha = 0;
    }
    return _addContent;
}

#pragma mark - 显示内容视图
- (ShowContentView *)showContent {
    if (!_showContent) {
        _showContent = [[ShowContentView alloc] init];
        _showContent.delegate = self;
    }
    return _showContent;
}

- (void)EditContentData {
    [UIView animateWithDuration:.3 animations:^{
        self.addContent.alpha = 1;
        [self.addContent.title becomeFirstResponder];
    }];
}


#pragma mark - 添加标签
- (void)BeginAddTag {
    [self.addTagsView setDefaultTags:self.showContent.chooseTagMarr];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.addTagsView.alpha = 1;
        self.showContent.alpha = 0;
    }];
}

- (AddTagsView *)addTagsView {
    if (!_addTagsView) {
        _addTagsView = [[AddTagsView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _addTagsView.bgImage = self.bgImg;
        _addTagsView.alpha = 0;
        _addTagsView.delegate = self;
    }
    return _addTagsView;
}

- (void)addTagsDone {
    [self.showContent setAddTags:self.addTagsView.chooseTagMarr];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.showContent.alpha = 1;
    }];
}

#pragma mark -  设置导航栏
- (void)setNavViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0];
    if ([self.createType isEqualToString:@"scene"]) {
        [self addNavViewTitle:NSLocalizedString(@"releaseVcTitle", nil)];
    }
    self.navTitle.textColor = [UIColor whiteColor];
    [self.cancelDoneBtn setImage:[UIImage imageNamed:@"icon_cancel"] forState:(UIControlStateNormal)];
    [self addCancelDoneButton];
    [self addDoneButton];
    [self.doneBtn addTarget:self action:@selector(releaseScene) forControlEvents:(UIControlEventTouchUpInside)];
}

#pragma mark - 确认发布场景
- (void)releaseScene {
    if ([self.createType isEqualToString:@"scene"]) {
        [self networkNewSceneData];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"a" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectFiuSceneId" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectFiuSceneTitle" object:nil];
}

@end
