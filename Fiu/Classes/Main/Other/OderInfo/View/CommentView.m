//
//  CommentView.m
//  parrot
//
//  Created by THN-Huangfei on 16/1/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "CommentView.h"

CGFloat const commentHeight = 354.0;

@interface CommentView ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *placeholderLbl;

- (IBAction)starBtnAction:(UIButton *)sender;

@end

@implementation CommentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.starInt = 5;
}

- (IBAction)starBtnAction:(UIButton *)sender {
    if (sender.tag - 100 == self.starInt) {
        return;
    }
    
    for (NSInteger i = 101; i <= 105; i++) {
        UIButton * button = (UIButton *)[self viewWithTag:i];
        if (i <= sender.tag) {
            [button setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
        } else {
            [button setImage:[UIImage imageNamed:@"star_invalid"] forState:UIControlStateNormal];
        }
    }
    self.starInt = sender.tag - 100;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(commentTextViewDidBeginEditing:)]) {
        [self.delegate commentTextViewDidBeginEditing:self];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(commentTextViewDidEndEditing:)]) {
        [self.delegate commentTextViewDidEndEditing:self];
    }
}

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

@end
