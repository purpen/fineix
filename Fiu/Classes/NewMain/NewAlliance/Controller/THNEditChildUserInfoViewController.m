//
//  THNEditChildUserInfoViewController.m
//  Fiu
//
//  Created by FLYang on 2017/5/5.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNEditChildUserInfoViewController.h"

static NSString *const URLSaveUser = @"/storage_manage/save";
static NSInteger const TEXTFIELD_TAG = 537;
static NSInteger const MAX_SCALE = 100;

@interface THNEditChildUserInfoViewController () {
    NSString *_name;
    NSString *_scale;
}

@end

@implementation THNEditChildUserInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)thn_networkEditChildUserInfo:(NSString *)addition userName:(NSString *)name {
    self.editRequest = [FBAPI postWithUrlString:URLSaveUser requestDictionary:@{@"id":self.childId, @"username":name, @"addition":addition} delegate:self];
    [self.editRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] integerValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"编辑成功"];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"-- %@ --", error);
    }];
}

- (void)thn_setEditUserInfo:(THNChildUserModel *)model {
    NSString *addition = [NSString stringWithFormat:@"%.2f", model.addition *100];
    NSString *userName = model.name;
    NSArray *dataArr = @[userName, addition];
    _name = userName;
    _scale = addition;
    
    NSArray *titleArr = @[@"    姓名", @"    分成比例(％)"];
    [self thn_creatTextFieldView:titleArr dataArr:dataArr];
}

/**
 创建输入视图

 @param titleArr 标题
 */
- (void)thn_creatTextFieldView:(NSArray *)titleArr dataArr:(NSArray *)dataArr {
    for (NSInteger idx = 0; idx < titleArr.count; ++ idx) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 64 + (44 * idx), SCREEN_WIDTH, 44)];
        textField.backgroundColor = [UIColor whiteColor];
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 110, 44)];
        leftLabel.text = titleArr[idx];
        leftLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        leftLabel.font = [UIFont systemFontOfSize:14];
        textField.leftView = leftLabel;
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        textField.font = [UIFont systemFontOfSize:14];
        textField.text = dataArr[idx];
        textField.tag = TEXTFIELD_TAG + idx;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:textField];
        
        if (textField.tag == TEXTFIELD_TAG +1) {
            self.scaleField = textField;
            textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#E5E5E5"];
        [textField addSubview:line];
        [self.view addSubview:textField];
    }
}

- (void)textFiledEditChanged:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    if (!position || !selectedRange) {
        switch (textField.tag) {
            case TEXTFIELD_TAG +0:
                _name = textField.text;
                break;
                
            case TEXTFIELD_TAG +1:
                if ([textField.text integerValue] > MAX_SCALE) {
                    [SVProgressHUD showInfoWithStatus:@"比例不能大于100%"];
                    textField.text = @"100";
                    return;
                }
                _scale = textField.text;
                break;
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navViewTitle.text = @"子账号管理";
    self.delegate = self;
    [self thn_addBarItemRightBarButton:@"保存" image:@""];
    [self thn_addNavBackBtn];
}

- (void)thn_rightBarItemSelected {
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            [view resignFirstResponder];
        }
    }
    
    [self thn_postEidtInfo];
    
}

- (void)thn_postEidtInfo {
    if (_name.length == 0 || _scale.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"资料编辑不完整"];
        return;
    }
    
    NSString *addition;
    if (_scale.length == 0) {
        addition = @"1";
    } else {
        addition = [NSString stringWithFormat:@"%f", [_scale floatValue] /100];
    }
    
    [self thn_networkEditChildUserInfo:addition userName:_name];
}

@end
