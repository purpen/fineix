//
//  TalentCertificationViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "TalentCertificationViewController.h"

@interface TalentCertificationViewController ()<FBNavigationBarItemsDelegate,UITextViewDelegate,UITextFieldDelegate>

@end

@implementation TalentCertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"达人认证";
    [self addBarItemLeftBarButton:nil image:@"icon_back"];
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.layer.cornerRadius = 3;
    self.certificationTFV.delegate = self;
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.promptLabel.hidden = YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    self.promptLabel.hidden = self.certificationTFV.text.length;
    [self.certificationTFV resignFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

- (IBAction)clickIdCardBtn:(UIButton *)sender {
    
}

- (IBAction)clickBusinessCardBtn:(UIButton *)sender {
}
- (IBAction)clickSubmitBtn:(UIButton *)sender {
}

-(void)leftBarItemSelected{
    [self.navigationController popViewControllerAnimated:YES];
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
