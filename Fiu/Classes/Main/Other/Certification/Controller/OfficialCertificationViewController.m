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
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *refusedView;
@property (weak, nonatomic) IBOutlet UIButton *applyAgineBtn;
@property (weak, nonatomic) IBOutlet UIView *waitingView;
@property (weak, nonatomic) IBOutlet UIView *throughView;
@property (weak, nonatomic) IBOutlet UIImageView *idTagesImageView;
@property (weak, nonatomic) IBOutlet UILabel *idTagesLabel;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@end

@implementation OfficialCertificationViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.firstView.hidden = NO;
    self.refusedView.hidden = YES;
    self.waitingView.hidden = YES;
    self.throughView.hidden = YES;
    FBRequest *request = [FBAPI postWithUrlString:@"/my/fetch_talent" requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"result  %@",result);
        NSDictionary *dataDict = [result objectForKey:@"data"];
        if (!result[@"success"]) {
            
        }else{
            //不是第一次，要编辑
            //1 正在等待审核
            if ([dataDict[@"verified"] isEqual:@(0)]) {
                self.firstView.hidden = YES;
                self.refusedView.hidden = YES;
                self.waitingView.hidden = NO;
                self.throughView.hidden = YES;
            }else if ([dataDict[@"verified"] isEqual:@(1)]){
                self.firstView.hidden = YES;
                self.refusedView.hidden = NO;
                self.waitingView.hidden = YES;
                self.throughView.hidden = YES;
            }
            //2 审核被拒绝
            else if ([dataDict[@"verified"] isEqual:@(2)]){
                self.firstView.hidden = YES;
                self.refusedView.hidden = YES;
                self.waitingView.hidden = YES;
                self.throughView.hidden = NO;
                NSArray *tagsAry = [NSArray arrayWithObjects:@"大拿",@"行家",@"行摄家",@"艺术范",@"手艺人",@"人来疯",@"赎回自由身",@"职业buyer", nil];
                int n = (int)[tagsAry indexOfObject:dataDict[@"expert_label"]];
                self.idTagesImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"tags%d",n+1]];
            }
            //3 审核通过
        
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
