//
//  THNDomainEditViewController.m
//  Fiu
//
//  Created by FLYang on 2017/3/10.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNDomainEditViewController.h"

static NSInteger const MaxTextCount = 140;
static NSInteger const categoryBtnTag = 532;
static NSInteger const categorySpace = ((SCREEN_WIDTH - ((105 * 3) - 15)) / 2);
static NSString *const URLCategory = @"/category/getlist";

@interface THNDomainEditViewController () {
    NSString *_oldCategoryTitle;
}

@end

@implementation THNDomainEditViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
    
    [self setViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.setInfoType == 8) {
        [self.writeBox becomeFirstResponder];
    } else {
        [self.editInputBox becomeFirstResponder];
    }
}

- (void)setViewUI {
    DomainSetInfoType setType = (DomainSetInfoType)self.setInfoType;
    switch (setType) {
        case DomainSetInfoTypeDes:
            [self thn_showWriteBox:self.infoData.des];
            [self setWriteBoxTextCount:self.infoData.des];
            break;
        case DomainSetInfoTypeTitle:
            [self thn_showInputBox:self.infoData.title andSubTitle:@"请输入20字以内的标题"];
            break;
        case DomainSetInfoTypeSubTitle:
            [self thn_showInputBox:self.infoData.subTitle andSubTitle:@"请输入20字以内的副标题"];
            break;
        case DomainSetInfoTypeCategory:
            _oldCategoryTitle = self.infoData.category.title;
            [self thn_networkDomainCategory];
            break;
        case DomainSetInfoTypeTags:
            [self thn_showInputBox:[self.infoData.tags componentsJoinedByString:@","] andSubTitle:@"每个标签不超过4个字，多个标签请用“ , ”分割"];
            break;
        case DomainSetInfoTypeAddress:
            NSLog(@"==== 地址");
            break;
        case DomainSetInfoTypePhoneNum:
            self.editInputBox.keyboardType = UIKeyboardTypePhonePad;
            [self thn_showInputBox:self.infoData.extra.tel andSubTitle:@"请输入地盘联系方式"];
            break;
        case DomainSetInfoTypeOpenTime:
            [self thn_showInputBox:self.infoData.extra.shopHours andSubTitle:@"请设定地盘营业的时间"];
            break;
    }
}

- (void)thn_showWriteBox:(NSString *)string {
    self.writeBox.text = string;
    [self.view addSubview:self.writeBox];
    [self.view addSubview:self.textCountLabel];
    [_textCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 40));
        make.bottom.right.equalTo(_writeBox).with.offset(0);
    }];
}

- (void)thn_showInputBox:(NSString *)string andSubTitle:(NSString *)subTitle {
    self.editInputBox.text = string;
    [self.view addSubview:self.editInputBox];
    
    self.hintLabel.text = subTitle;
    [self.view addSubview:self.hintLabel];
}

- (UITextField *)editInputBox {
    if (!_editInputBox) {
        _editInputBox = [[UITextField alloc] initWithFrame:CGRectMake(0, 74, SCREEN_WIDTH, 44)];
        _editInputBox.textColor = [UIColor colorWithHexString:@"#222222"];
        _editInputBox.font = [UIFont systemFontOfSize:16];
        _editInputBox.backgroundColor = [UIColor whiteColor];
        _editInputBox.clearButtonMode = UITextFieldViewModeWhileEditing;
        _editInputBox.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
        _editInputBox.leftViewMode = UITextFieldViewModeAlways;
        _editInputBox.returnKeyType = UIReturnKeyDone;
        _editInputBox.delegate = self;
    }
    return _editInputBox;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self changeSaveButtonAlpha:1.0];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length == 0) {
        [self changeSaveButtonAlpha:0.0];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (UITextView *)writeBox {
    if (!_writeBox) {
        _writeBox = [[UITextView alloc] initWithFrame:CGRectMake(0, 74, SCREEN_WIDTH, 170)];
        _writeBox.font = [UIFont systemFontOfSize:14];
        _writeBox.textColor = [UIColor colorWithHexString:@"#666666"];
        _writeBox.backgroundColor = [UIColor whiteColor];
        _writeBox.textContainerInset = UIEdgeInsetsMake(15, 10, 15, 10);
        _writeBox.textAlignment = NSTextAlignmentLeft;
        _writeBox.delegate = self;
    }
    return _writeBox;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self changeSaveButtonAlpha:1.0];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        [self changeSaveButtonAlpha:0.0];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    if (textView.text.length >= MaxTextCount) {
        [SVProgressHUD showInfoWithStatus:@"最多输入140字"];
        self.writeBox.text = [textView.text substringToIndex:MaxTextCount];
    }
    [self setWriteBoxTextCount:textView.text];
}

- (UILabel *)textCountLabel {
    if (!_textCountLabel) {
        _textCountLabel = [[UILabel alloc] init];
        _textCountLabel.font = [UIFont systemFontOfSize:14];
        _textCountLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _textCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textCountLabel;
}

- (void)setWriteBoxTextCount:(NSString *)text {
    NSString *textCount = [NSString stringWithFormat:@"%zi", text.length];
    self.textCountLabel.text = textCount;
}

#pragma mark - 获取地盘分类
- (void)thn_networkDomainCategory {
    self.categoryRequest = [FBAPI postWithUrlString:URLCategory requestDictionary:@{@"domain":@"12"} delegate:self];
    [self.categoryRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dict = [result valueForKey:@"data"];
        NSArray *dataArr = dict[@"rows"];
        for (NSDictionary *dataDic in dataArr) {
            [self.titleMarr addObject:dataDic[@"title"]];
            [self.idMarr addObject:[NSString stringWithFormat:@"%zi", [dataDic[@"_id"] integerValue]]];
        }
        if (self.titleMarr.count) {
            [self creatCategoryButton:self.titleMarr];
        }
        NSLog(@"======== 分类：%@", self.idMarr);
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"---- %@ ---", error);
    }];
}

- (void)creatCategoryButton:(NSMutableArray *)titleArr {
    self.rightBtn.alpha = 1.0f;
    
    if (_oldCategoryTitle.length) {
        for (NSInteger idx = 0; idx < titleArr.count; ++ idx) {
            UIButton *categoryBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 40)];
            categoryBtn.layer.borderWidth = 0.5f;
            categoryBtn.layer.cornerRadius = 3.0f;
            categoryBtn.layer.masksToBounds = YES;
            [categoryBtn setTitle:titleArr[idx] forState:(UIControlStateNormal)];
            categoryBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [categoryBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:(UIControlStateNormal)];
            [categoryBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateSelected)];
            
            categoryBtn.tag = categoryBtnTag + idx;
            if ([titleArr[idx] isEqualToString:_oldCategoryTitle]) {
                categoryBtn.selected = YES;
                categoryBtn.backgroundColor = [UIColor colorWithHexString:MAIN_COLOR];
                categoryBtn.layer.borderColor = [UIColor colorWithHexString:MAIN_COLOR].CGColor;
                self.nowCategoryBtn = categoryBtn;
            
            } else {
                categoryBtn.selected = NO;
                categoryBtn.backgroundColor = [UIColor whiteColor];
                categoryBtn.layer.borderColor = [UIColor colorWithHexString:@"#666666"].CGColor;
            }
            
            [categoryBtn addTarget:self action:@selector(categoryBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
            
            [self.view addSubview:categoryBtn];
            [categoryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(90, 40));
                make.left.equalTo(self.view.mas_left).with.offset(categorySpace + (105 * (idx % 3)));
                make.top.equalTo(self.view.mas_top).with.offset(79 + (55 * (idx % 2)));
            }];
        }
    }
}

- (void)categoryBtnClick:(UIButton *)button {
    if (button.selected == NO) {
        self.nowCategoryBtn.selected = NO;
        self.nowCategoryBtn.backgroundColor = [UIColor whiteColor];
        self.nowCategoryBtn.layer.borderColor = [UIColor colorWithHexString:@"#666666"].CGColor;
        
        button.selected = YES;
        button.backgroundColor = [UIColor colorWithHexString:MAIN_COLOR];
        button.layer.borderColor = [UIColor colorWithHexString:MAIN_COLOR].CGColor;
        self.nowCategoryBtn = button;
    }
}

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.editInputBox.frame), SCREEN_WIDTH - 30, 44)];
        _hintLabel.font = [UIFont systemFontOfSize:12];
        _hintLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _hintLabel;
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    NSArray *titleArr = @[@"地盘标题", @"地盘副标题", @"地盘分类", @"地盘标签", @"地盘地址", @"地盘电话", @"地盘营业时间", @"地盘简介"];
    self.navViewTitle.text = titleArr[self.setInfoType - 1];
    self.delegate = self;
    [self thn_addBarItemRightBarButton:@"保存" image:@""];
    self.rightBtn.alpha = 0.0f;
}

- (void)thn_rightBarItemSelected {
    NSLog(@"=== 保存");
}

- (void)changeSaveButtonAlpha:(CGFloat)alpha {
    [UIView animateWithDuration:0.3 animations:^{
        self.rightBtn.alpha = alpha;
    }];
}

#pragma mark -
- (NSMutableArray *)titleMarr {
    if (!_titleMarr) {
        _titleMarr = [NSMutableArray array];
    }
    return _titleMarr;
}

- (NSMutableArray *)idMarr {
    if (!_idMarr) {
        _idMarr = [NSMutableArray array];
    }
    return _idMarr;
}
@end
