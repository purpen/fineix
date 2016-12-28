//
//  RefundmentViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/5/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "RefundmentViewController.h"
#import "OrderInfoCell.h"
#import "OrderInfoModel.h"
#import "TYAlertView.h"
#import "UIView+TYAlertView.h"
#import "SVProgressHUD.h"

@interface RefundmentViewController ()<FBNavigationBarItemsDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *reasonLbl;
@property (weak, nonatomic) IBOutlet UILabel *amountLbl;
@property (weak, nonatomic) IBOutlet UIView *explainView;
@property (weak, nonatomic) IBOutlet UITextView *explainTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLbl;
@property (nonatomic, assign) NSInteger optionInt;
@end

@implementation RefundmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.navViewTitle.text = @"申请退款";
    self.explainTextView.delegate = self;
    // Do any additional setup after loading the view from its nib.
    if (self.orderInfo == nil) {
        self.orderInfo = self.orderInfoCell.orderInfo;
    }
    
    self.optionInt = 1;
    self.amountLbl.text = [NSString stringWithFormat:@"￥%.2f", [self.orderInfo.totalMoney floatValue]];
    
    self.explainView.hidden = YES;
}
- (IBAction)reasonBtnAction:(UIButton *)sender {
    TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"选择退款原因" message:nil];
    [alertView addAction:[TYAlertAction actionWithTitle:@"我不想要了" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        self.optionInt = 1;
        self.reasonLbl.text = action.title;
        self.explainView.hidden = YES;
    }]];
    [alertView addAction:[TYAlertAction actionWithTitle:@"其他" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        self.optionInt = 0;
        self.reasonLbl.text = action.title;
        self.explainView.hidden = NO;
    }]];
    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
    }]];
    [alertView showInController:self preferredStyle:TYAlertControllerStyleActionSheet backgoundTapDismissEnable:YES];
}
- (IBAction)commitBtnAction:(UIButton *)sender {
    if (self.explainTextView.text.length > 200) {
        [SVProgressHUD showInfoWithStatus:@"退款说明不能多于200个字"];
        return;
    }
    FBRequest * request = [FBAPI postWithUrlString:@"/shopping/apply_refund" requestDictionary:@{@"rid": self.orderInfo.rid, @"option": [NSNumber numberWithInteger:self.optionInt], @"content": self.explainTextView.text} delegate:self];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        
        if (self.isFromOrderDetail) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            if ([self.delegate1 respondsToSelector:@selector(operationActionWithCell:)]) {
                [self.delegate1 operationActionWithCell:self.orderInfoCell];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        [SVProgressHUD showSuccessWithStatus:@"申请成功"];
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        self.placeholderLbl.hidden = true;
    } else {
        self.placeholderLbl.hidden = false;
    }
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
