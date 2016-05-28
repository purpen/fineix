//
//  OfficialCertificationViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/5/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "OfficialCertificationViewController.h"
#import "TheOfficialCertificationViewController.h"

@interface OfficialCertificationViewController ()
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;

@end

@implementation OfficialCertificationViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    FBRequest *request = [FBAPI postWithUrlString:@"/my/fetch_talent" requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dataDict = [result objectForKey:@"data"];
        if (dataDict.count == 1) {
            //第一次，要提交
            [self.applyBtn setTitle:@"申请官方认证" forState:UIControlStateNormal];
        }else{
            //不是第一次，要编辑
            [self.applyBtn setTitle:@"编辑身份标签" forState:UIControlStateNormal];
        }
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navViewTitle.text = @"官方认证";
    self.applyBtn.layer.masksToBounds = YES;
    self.applyBtn.layer.cornerRadius = 3;
    [self.applyBtn addTarget:self action:@selector(clickApplyBtn:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clickApplyBtn:(UIButton*)sender{
    TheOfficialCertificationViewController *vc = [[TheOfficialCertificationViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
