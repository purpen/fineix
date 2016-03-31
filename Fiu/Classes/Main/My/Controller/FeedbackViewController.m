//
//  FeedbackViewController.m
//  fineix
//
//  Created by THN-Dong on 16/3/28.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FeedbackViewController.h"
#import "SVProgressHUD.h"
#import "FBRequest.h"
#import "FBAPI.h"

@interface FeedbackViewController ()<UITextViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *promptLabel;//写意见时的提示label

@property (weak, nonatomic) IBOutlet UITextView *opinionTextView;//意见textView
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;//联系方式textFiled
@end

NSString *const feedbackUrl = @"/gateway/feedback";//意见反馈接口

@implementation FeedbackViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    //输入自己的意见
    self.opinionTextView.delegate = self;
    //输入联系方式
    self.contactTextField.delegate = self;
    
    
    //进行网络请求
}

//UITextViewDelegate  输入文字提示label消失
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 0) {
        self.promptLabel.hidden = YES;
    }else{
        self.promptLabel.hidden = NO;
    }
}


//UITextViewDelegate  点击确认键键盘弹回
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

//UITextFieldDelegate 点击换行键键盘弹回
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//将要进入界面时隐藏tabbar
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

//将要退出界面时显示tabbar
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

//回退按钮
- (IBAction)backBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//提交
//提交按钮
- (IBAction)submitBtn:(UIButton *)sender {
    if (self.opinionTextView.text.length > 200) {
        [SVProgressHUD showInfoWithStatus:@"不能多于200个字"];
        return;
    }
    //封装参数
    NSDictionary *params = @{
                             @"content":self.opinionTextView.text,
                             @"contact":self.contactTextField.text
                             };
    FBRequest *request = [FBAPI postWithUrlString:feedbackUrl requestDictionary:params delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"%@",result);
        //根据返回信息判断是否反馈成功
        NSNumber *successStr = [result objectForKey:@"success"];
        //反馈成功
        if ([successStr isEqualToNumber:@1]) {
            [SVProgressHUD showSuccessWithStatus:@"反馈成功"];
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }
        //反馈失败
        else{
            [SVProgressHUD showErrorWithStatus:@"反馈失败"];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        //发送请求失败
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

@end
