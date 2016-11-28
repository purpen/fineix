//
//  THNApplyRefundView.m
//  Fiu
//
//  Created by FLYang on 2016/11/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNApplyRefundView.h"

static NSInteger const textFieldTag = 757;

@interface THNApplyRefundView () {
    NSInteger _type;
    NSArray *_titleArr;
    NSArray *_placeholderArr;
    NSArray *_refundReasonArr;
    UITextField *_chooseTextField;
    UITextField *_writeTextField;
}

@end

@implementation THNApplyRefundView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self set_viewUI];
    }
    return self;
}

- (void)set_viewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    
}

- (void)thn_setRefundInfoData:(NSDictionary *)data {
    [self thn_setRefundPrice:[[data valueForKey:@"refund_price"] floatValue]];
    if (_type == 1) {
         _refundReasonArr = [data valueForKey:@"refund_reason"];
    } else if (_type == 2) {
         _refundReasonArr = [data valueForKey:@"return_reason"];
    }
    
    [self addSubview:self.reasonTable];
}

- (void)thn_showRefundReasonTable:(BOOL)show {
    CGRect tableFrame = self.reasonTable.frame;
    if (show) {
        tableFrame = CGRectMake(15, CGRectGetMaxY(_chooseTextField.frame), SCREEN_WIDTH - 30, _refundReasonArr.count *35);
    } else {
        tableFrame = CGRectMake(15, CGRectGetMaxY(_chooseTextField.frame), SCREEN_WIDTH - 30, 0);
    }
    [UIView animateWithDuration:.3 animations:^{
        self.reasonTable.frame = tableFrame;
    }];
}

//  设置退款金额
- (void)thn_setRefundPrice:(CGFloat)price {
    UITextField *textField = (UITextField *)[self viewWithTag:textFieldTag];
    textField.text = [NSString stringWithFormat:@"￥%.2f", price];
    textField.userInteractionEnabled = NO;
}

- (NSArray *)thn_setShowType:(NSInteger)type {
    if (type == 1) {
        _titleArr = @[@"退款金额", @"退款原因", @"退款说明"];
        _placeholderArr = @[@"", @"请选择退款原因", @"请输入退款说明"];
    } else if (type == 2) {
        _titleArr = @[@"退款金额", @"退货原因", @"退货说明"];
        _placeholderArr = @[@"", @"请选择退货原因", @"请输入退货说明"];
    }
    _type = type;
    
    [self set_defaultTextLable];
    [self set_defaultTextField];
    
    return _titleArr;
}

- (void)set_defaultTextLable {
    for (NSUInteger idx = 0; idx < _titleArr.count; ++ idx) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15 + 80 * idx, 100, 15)];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textColor = [UIColor colorWithHexString:@"#666666"];
        lab.text = _titleArr[idx];
        [self addSubview:lab];
    }
}

- (void)set_defaultTextField {
    for (NSUInteger idx = 0; idx < _titleArr.count; ++ idx) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 35 + 80 * idx, SCREEN_WIDTH - 30, 44)];
        textField.backgroundColor = [UIColor whiteColor];
        textField.font = [UIFont systemFontOfSize:14];
        textField.textColor = [UIColor colorWithHexString:@"#222222"];
        textField.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC" alpha:.5].CGColor;
        textField.layer.borderWidth = 0.5f;
        textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];;
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        textField.placeholder = _placeholderArr[idx];
        textField.tag = textFieldTag + idx;
        
        if (textField.tag == textFieldTag + 1) {
            UIImageView *rigthImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
            rigthImage.image = [UIImage imageNamed:@"icon_upward_down"];
            rigthImage.contentMode = UIViewContentModeCenter;
            textField.rightView = rigthImage;
            textField.rightViewMode = UITextFieldViewModeAlways;
            _chooseTextField = textField;
        
        } else if (textField.tag == textFieldTag + 2) {
            _writeTextField = textField;
        }
        
        [self addSubview:textField];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _chooseTextField) {
        [textField endEditing:YES];
        if (self.delegate && [self.delegate respondsToSelector:@selector(thn_beginChooseRefundReason)]) {
            [self.delegate thn_beginChooseRefundReason];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _writeTextField) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(thn_finishWritingRefundReason:)]) {
            [self.delegate thn_finishWritingRefundReason:textField.text];
        }
        [textField endEditing:YES];
        return YES;
    }
    return NO;
}

- (UITableView *)reasonTable {
    if (!_reasonTable) {
        _reasonTable = [[UITableView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_chooseTextField.frame), SCREEN_WIDTH - 30, 0) style:(UITableViewStylePlain)];
        _reasonTable.delegate = self;
        _reasonTable.dataSource = self;
        _reasonTable.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC" alpha:.5].CGColor;
        _reasonTable.layer.borderWidth = 0.5f;
        _reasonTable.bounces = NO;
        _reasonTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _reasonTable;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _refundReasonArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reasonCellID"];
    cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"reasonCellID"];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    if (_refundReasonArr.count) {
        cell.textLabel.text = [_refundReasonArr valueForKey:@"title"][indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self thn_showRefundReasonTable:NO];
    _chooseTextField.text = [_refundReasonArr valueForKey:@"title"][indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(thn_doneChooseRefundReasonId:)]) {
        [self.delegate thn_doneChooseRefundReasonId:[[_refundReasonArr valueForKey:@"id"][indexPath.row] integerValue]];
    }
}

@end
