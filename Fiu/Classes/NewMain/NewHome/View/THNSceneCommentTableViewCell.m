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
    }
    return self;
}

#pragma mark - setModel
- (void)thn_setScenecommentData:(NSDictionary *)commentModel {
    HomeSceneListComments *model = [[HomeSceneListComments alloc] initWithDictionary:commentModel];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.userAvatarUrl] forState:(UIControlStateNormal)];
    NSString *comment = [NSString stringWithFormat:@"%@: %@", model.userNickname, model.content];
    [self getContentWithComment:comment withUserName:model.userNickname withUserId:[NSString stringWithFormat:@"%zi", model.userId]];
    CGSize size = [_comment boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 70, 0)];
    
    if (size.height < 35.0f) {
        self.cellHigh = 35.0f;
    } else {
        self.cellHigh = size.height;
    }
}

//  检索评论中的用户昵称
- (void)getContentWithComment:(NSString *)content withUserName:(NSString *)userName withUserId:(NSString *)userId {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0f;
    
    self.comment.attributedText = [[NSAttributedString alloc] initWithString:content
                                                                  attributes:@{(NSString *)kCTForegroundColorAttributeName:(__bridge id)[UIColor colorWithHexString:@"#666666"].CGColor,
                                                                               NSFontAttributeName:[UIFont systemFontOfSize:12],
                                                                               NSParagraphStyleAttributeName:paragraphStyle}];
    NSRange range = NSMakeRange(0, userName.length);
    NSString *urlStr = [NSString stringWithFormat:@"scheme://userId=%@", userId];
    NSString *userStr = [urlStr stringByAddingPercentEscapesUsingEncoding:(NSUTF8StringEncoding)];
    [self.comment addLinkToURL:[NSURL URLWithString:userStr] withRange:range];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSString *userUrl = [[url absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *user = [userUrl substringFromIndex:16];
#pragma unused(user)
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
        make.top.equalTo(_graybackView.mas_top).with.offset(0);
    }];
    
    [self addSubview:self.comment];
    [_comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_graybackView.mas_left).with.offset(40);
        make.right.equalTo(_graybackView.mas_right).with.offset(-10);
        make.top.equalTo(_graybackView.mas_top).with.offset(5);
        make.bottom.equalTo(_graybackView.mas_bottom).with.offset(0);
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
        _headImage.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
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
        _comment.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
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
//        _comment.backgroundColor = [UIColor orangeColor];
    }
    return _comment;
}

@end
