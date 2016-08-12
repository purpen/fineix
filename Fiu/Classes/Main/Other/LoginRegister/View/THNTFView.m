//
//  THNTFView.m
//  Fiu
//
//  Created by THN-Dong on 16/8/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNTFView.h"

@implementation THNTFView

static NSString * const XMGPlacerholderColorKeyPath = @"_placeholderLabel.textColor";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UITextField *textField = [[UITextField alloc] initWithFrame:self.bounds];
        textField.hidden = YES;
        
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.keyboardAppearance = UIKeyboardAppearanceDark;
        [textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:textField];
        self.textField = textField;
        self.textField.tag=20;
//        [self.textField becomeFirstResponder];
    }
    return self;
}

#pragma mark - 文本框内容改变
- (void)textChange:(UITextField *)textField {
    NSString *password = textField.text;
    if (password.length > self.elementCount) {
        return;
    }
    
    for (int i = 0; i < _dataSource.count; i++)
    {
        UITextField *pwdTextField= [_dataSource objectAtIndex:i];
        if (i < password.length) {
            NSString *pwd = [password substringWithRange:NSMakeRange(i, 1)];
            pwdTextField.text = pwd;
        } else {
            pwdTextField.text = nil;
        }
        
    }
    
    if (password.length == _dataSource.count)
    {
        [textField resignFirstResponder];//隐藏键盘
    }
    
//    !self.passwordBlock ? : self.passwordBlock(textField.text);
    
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray arrayWithCapacity:self.elementCount];
    }
    return _dataSource;
}

- (void)setElementCount:(NSUInteger)elementCount {
    _elementCount = elementCount;
    for (int i = 0; i < self.elementCount; i++)
    {
        UITextField *pwdTextField = [[UITextField alloc] init];
//        pwdTextField.layer.borderColor = _elementColor.CGColor;
        pwdTextField.enabled = NO;
        pwdTextField.tag=i+1;
//        pwdTextField.backgroundColor=[UIColor whiteColor];
        pwdTextField.textAlignment = NSTextAlignmentCenter;
        pwdTextField.secureTextEntry = NO;//设置密码模式
//        pwdTextField.layer.borderWidth = 0.5;
        pwdTextField.placeholder = @"*";
        pwdTextField.textColor = [UIColor whiteColor];
        pwdTextField.userInteractionEnabled = NO;
        pwdTextField.font = [UIFont systemFontOfSize:15];
        // 修改占位文字颜色
        [pwdTextField setValue:[UIColor whiteColor] forKeyPath:XMGPlacerholderColorKeyPath];
        [self insertSubview:pwdTextField belowSubview:self.textField];
        
        [self.dataSource addObject:pwdTextField];
    }
}

-(void)setNoSecure
{
    for (UITextField *text in self.subviews) {
        /**
         *  除了父输入框，其余输入框键盘全部设置明文
         */
        if (text.tag!=20) {
            text.secureTextEntry=NO;
        }
    }
}

- (void)setElementMargin:(NSUInteger)elementMargin {
    _elementMargin = elementMargin;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    BOOL flag = NO;
    BOOL flag2 = NO;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = (self.bounds.size.width - (self.elementCount - 1) * self.elementMargin) / self.elementCount;
    CGFloat h = self.bounds.size.height;
    for (NSUInteger i = 0; i < self.dataSource.count; i++) {
        UITextField *pwdTextField = [_dataSource objectAtIndex:i];
        x = i * (w + self.elementMargin);
        
        if (i == 3) {
            UILabel *placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, -3, 10, h)];
            placeLabel.text = @"-";
            placeLabel.textColor = [UIColor whiteColor];
            [self addSubview:placeLabel];
            flag = YES;
        }
        if (flag) {
            x += 10;
        }
        
        if (i == 7) {
            UILabel *placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, -3, 10, h)];
            placeLabel.text = @"-";
            placeLabel.textColor = [UIColor whiteColor];
            [self addSubview:placeLabel];
            flag2 = YES;
        }
        if (flag2) {
            x += 10;
        }
        
        pwdTextField.frame = CGRectMake(x, y, w, h);
        
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textField becomeFirstResponder];
}

@end
