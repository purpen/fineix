//
//  ReportViewController.m
//  Fiu
//
//  Created by FLYang on 16/5/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ReportViewController.h"

static NSInteger const reportBtnTag = 612;
static NSString *const URLReport = @"/report_tip/save";

@interface ReportViewController ()

@end

@implementation ReportViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setReportVcUI];
    
}

#pragma mark - 网络请求
- (void)networkReportData:(NSString *)type {
    self.reportRequest = [FBAPI postWithUrlString:URLReport requestDictionary:@{@"target_id":self.targetId, @"type":@"4", @"evt":type, @"application":@"3", @"from_to":@"3"} delegate:self];
    [self.reportRequest startRequestSuccess:^(FBRequest *request, id result) {
        [SVProgressHUD showSuccessWithStatus:[result valueForKey:@"message"]];
        [self setReportDoneUI];
        [self.rightBtn setTitle:@"完成" forState:(UIControlStateNormal)];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - 
- (void)setReportVcUI {
    NSArray * titleArr = [NSArray arrayWithObjects:@"举报图片原因",@"色情暴力信息",@"盗图",@"广告／欺诈信息", nil];
    for (NSInteger idx = 0; idx < 4; ++ idx) {
        UIButton * reportBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 64 + (44 * idx), SCREEN_WIDTH, 44)];
        reportBtn.backgroundColor = [UIColor whiteColor];
        [reportBtn setTitle:titleArr[idx] forState:(UIControlStateNormal)];
        reportBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        [reportBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:(UIControlStateNormal)];
        reportBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [reportBtn setTitleEdgeInsets:(UIEdgeInsetsMake(0, 15, 0, 0))];
        reportBtn.tag = reportBtnTag + idx;
        [reportBtn addTarget:self action:@selector(reportBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:reportBtn];
    }
    
    for (NSInteger jdx = 0; jdx < 3; ++ jdx) {
        UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(0, 107 + (43 * jdx), SCREEN_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithHexString:lineGrayColor];
        [self.view addSubview:line];
    }
}

#pragma mark - 点击举报按钮
- (void)reportBtnClick:(UIButton *)button {
    if (button.tag - reportBtnTag > 0) {
        [self networkReportData:[NSString stringWithFormat:@"%zi", button.tag - reportBtnTag]];
    }
}

#pragma mark - 举报完成的界面
- (void)setReportDoneUI {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    view.backgroundColor = [UIColor colorWithHexString:grayLineColor];
    [self.view addSubview:view];
    
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH - 30, 40)];
    lab.textColor = [UIColor colorWithHexString:titleColor];
    lab.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    lab.numberOfLines = 0;
    lab.text = @"感谢你的举报，如果此照片违反了我们的规定，我们会将其移除。";
    [view addSubview:lab];
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    self.view.backgroundColor = [UIColor colorWithHexString:grayLineColor];
    self.navViewTitle.text = NSLocalizedString(@"ReportVcTitle", nil);
    [self addBarItemRightBarButton:@"取消" image:nil isTransparent:NO];
    self.delegate = self;
}

//  取消
- (void)rightBarItemSelected {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
