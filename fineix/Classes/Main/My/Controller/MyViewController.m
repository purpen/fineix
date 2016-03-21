//
//  MyViewController.m
//  fineix
//
//  Created by THN-Dong on 16/3/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MyViewController.h"
#import "FBLoginRegisterViewController.h"

@interface MyViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headPortraitImageV;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageV;


@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setImagesRoundedCorners:27.0 :_headPortraitImageV];
    [self setImagesRoundedCorners:10.0 :_levelImageV];
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"登录/注册" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertV show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSLog(@"aaa");
        UIStoryboard *loginReginStory = [UIStoryboard storyboardWithName:@"LoginRegisterController" bundle:[NSBundle mainBundle]];
        FBLoginRegisterViewController * loginRegisterVC = [loginReginStory instantiateViewControllerWithIdentifier:@"FBLoginRegisterViewController"];
        //[self presentViewController:loginRegisterVC animated:YES completion:nil];
        [self.navigationController pushViewController:loginRegisterVC animated:YES];
    }
}

-(void)setImagesRoundedCorners:(float)radius :(UIImageView*)v{
    v.layer.masksToBounds = YES;
    v.layer.cornerRadius = 27.0;
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
