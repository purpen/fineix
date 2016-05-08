//
//  AddTagViewController.m
//  fineix
//
//  Created by FLYang on 16/3/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AddTagViewController.h"

static NSString *const URLUserTag = @"/my/my_recent_tags";
static NSString *const URLAllTag = @"/scene_tags/getlist";

@interface AddTagViewController ()

@end

@implementation AddTagViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavViewUI];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self networkTagListData];
}

#pragma mark - 网络请求
#pragma mark 标签列表
- (void)networkTagListData {
    self.tagRequest = [FBAPI getWithUrlString:URLAllTag requestDictionary:@{@"type":@"1"} delegate:self];
    [self.tagRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"一级标签：%@", [[[[result valueForKey:@"data"] valueForKey:@"1"] valueForKey:@"children"] valueForKey:@"title_cn"]);
        NSLog(@"一级下的二级标签：%@", [[[[[result valueForKey:@"data"] valueForKey:@"1"] valueForKey:@"children"] valueForKey:@"children"] valueForKey:@"title_cn"]);
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - 设置顶部导航栏
- (void)setNavViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navView.backgroundColor = [UIColor whiteColor];
    [self addNavViewTitle:NSLocalizedString(@"addTagVcTitle", nil)];
    self.navTitle.textColor = [UIColor blackColor];
    [self addLine];
    [self addBackButton:@"icon_back"];
    [self.navView addSubview:self.sureBtn];
}


#pragma mark - 确定按钮
- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60), 0, 50, 50)];
        [_sureBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:Font_ControllerTitle];
        [self.sureBtn setTitle:NSLocalizedString(@"sure", nil) forState:(UIControlStateNormal)];
    }
    return _sureBtn;
}

@end
