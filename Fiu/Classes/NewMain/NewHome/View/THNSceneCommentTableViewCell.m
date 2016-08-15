//
//  THNSceneCommentTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/8/10.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNSceneCommentTableViewCell.h"
#import "UILable+Frame.h"

@implementation THNSceneCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self setCellUI];
        [self getContentWithComment:@"Fynn: 今天的天气真不错啊哈气真不错啊哈气真不错啊哈气真不错啊哈哈哈哈"];
        CGSize size = [_comment boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 50, 0)];
        self.cellHigh = size.height*1.3;
    }
    return self;
}

#pragma mark - setModel
- (void)thn_setScenecommentData:(HomeSceneListRow *)commentModel {
    NSLog(@"－－－－－－－－－－－－－     评论%@", [commentModel.comments valueForKey:@"comment"]);
//    NSString *comment = [NSString stringWithFormat:@"%@: %@", [commentModel.comments valueForKey:@"userNickname"], [commentModel.comments valueForKey:@"comment"]];

//    [self getContentWithComment:@"Fynn: 今天的天气真不错啊哈哈哈哈"];
//    CGSize size = [_comment boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 50, 0)];
//    self.cellHigh = size.height*1.5;
    
}

//  检索评论中的用户昵称
- (void)getContentWithComment:(NSString *)content {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0f;
    self.comment.attributedText = [[NSAttributedString alloc] initWithString:content
                                                                  attributes:@{(NSString *)kCTForegroundColorAttributeName:(__bridge id)[UIColor colorWithHexString:@"#666666"].CGColor,
                                                                               NSFontAttributeName:[UIFont systemFontOfSize:12],
                                                                               NSParagraphStyleAttributeName:paragraphStyle}];
    NSString *userId = @"719877";
    NSRange range = NSMakeRange(0, @"Fynn： ".length);
    NSString *urlStr = [NSString stringWithFormat:@"scheme://userId=%@", userId];
    NSString *userStr = [urlStr stringByAddingPercentEscapesUsingEncoding:(NSUTF8StringEncoding)];
    [self.comment addLinkToURL:[NSURL URLWithString:userStr] withRange:range];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSString *userUrl = [[url absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *user = [userUrl substringFromIndex:16];
    NSLog(@"＝＝＝＝＝＝＝＝＝＝＝＝＝ 用户iD:%@", user);
}

#pragma mark - setUI
- (void)setCellUI {
    [self addSubview:self.graybackView];
    [_graybackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.top.bottom.equalTo(self).with.offset(0);
    }];
    
    [self addSubview:self.headImage];
    [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.left.equalTo(_graybackView.mas_left).with.offset(10);
        make.top.equalTo(_graybackView.mas_top).with.offset(5);
    }];
    
    [self addSubview:self.comment];
    [_comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_graybackView).with.offset(40);
        make.right.equalTo(_graybackView).with.offset(-10);
        make.top.equalTo(_graybackView).with.offset(0);
        make.bottom.equalTo(_graybackView).with.offset(-5);
    }];
}

#pragma mark - init
- (UIView *)graybackView {
    if (!_graybackView) {
        _graybackView = [[UIView alloc] init];
        _graybackView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    }
    return _graybackView;
}

- (UIButton *)headImage {
    if (!_headImage) {
        _headImage = [[UIButton alloc] init];
        _headImage.backgroundColor = [UIColor colorWithHexString:@"#000000"];
        _headImage.layer.cornerRadius = 24/2;
        _headImage.layer.masksToBounds = YES;
    }
    return _headImage;
}

- (TTTAttributedLabel *)comment {
    if (!_comment) {
        _comment = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _comment.numberOfLines = 0;
        _comment.delegate = self;
        _comment.enabledTextCheckingTypes = NSTextCheckingTypeLink;
        NSDictionary *linkAttributes = @{(NSString *)kCTUnderlineStyleAttributeName:[NSNumber numberWithBool:NO],
                                         (NSString *)kCTFontAttributeName:[UIFont boldSystemFontOfSize:12],
                                         (NSString *)kCTForegroundColorAttributeName:(__bridge id)[UIColor colorWithHexString:BLACK_COLOR].CGColor
                                         };
        _comment.linkAttributes = linkAttributes;
        NSDictionary *activelinkAttributes = @{(NSString *)kCTUnderlineStyleAttributeName:[NSNumber numberWithBool:YES],
                                               (NSString *)kCTFontAttributeName:[UIFont boldSystemFontOfSize:12],
                                               (NSString *)kCTForegroundColorAttributeName:(__bridge id)[UIColor colorWithHexString:BLACK_COLOR].CGColor
                                               };
        _comment.activeLinkAttributes = activelinkAttributes;
    }
    return _comment;
}

@end
