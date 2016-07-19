//
//  FBLoginRegisterViewController.m
//  fineix
//
//  Created by THN-Dong on 16/3/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBLoginRegisterViewController.h"


@interface FBLoginRegisterViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;


@end

@implementation FBLoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    self.signupBtn.layer.masksToBounds = YES;
    self.signupBtn.layer.cornerRadius = 3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//取消按钮
- (IBAction)cancelBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
