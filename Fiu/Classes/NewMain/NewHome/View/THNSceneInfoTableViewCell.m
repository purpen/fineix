//
//  THNSceneInfoTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/8/9.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNSceneInfoTableViewCell.h"
#import "THNSceneTagsCollectionViewCell.h"
#import "UILable+Frame.h"
#import "SearchViewController.h"

static NSString *const sceneTagsCellId = @"SceneTagsCellId";

@interface THNSceneInfoTableViewCell ()

@end

@implementation THNSceneInfoTableViewCell

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
- (void)thn_setSceneContentData:(HomeSceneListRow *)contentModel {
    [self getContentWithTags:contentModel.des];
    
    CGSize size = [_content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 50, 0)];
    if (size.height*1.5 <= 65) {
        self.defaultCellHigh = size.height*1.5 + 10;
    } else {
        self.defaultCellHigh = 65;
    }
    self.cellHigh = size.height*1.5;
}

//  检索描述内容中的标签
- (void)getContentWithTags:(NSString *)content {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0f;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    self.content.attributedText = [[NSAttributedString alloc] initWithString:content
                                                                  attributes:@{(NSString *)kCTForegroundColorAttributeName:(__bridge id)[UIColor colorWithHexString:@"#666666"].CGColor,
                                                                               NSFontAttributeName:[UIFont systemFontOfSize:12],
                                                                               NSParagraphStyleAttributeName:paragraphStyle}];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\#[^\\s]*" options:0 error:nil];
    NSArray *arr = [regex matchesInString:content options:0 range:NSMakeRange(0, content.length)];
    for (NSUInteger idx = 0; idx < arr.count; ++ idx) {
        NSTextCheckingResult *result = arr[idx];
        NSString *str = [content substringWithRange:result.range];
        NSString *urlStr = [NSString stringWithFormat:@"scheme://tag=%@", str];
        NSString *tagStr = [urlStr stringByAddingPercentEscapesUsingEncoding:(NSUTF8StringEncoding)];
        [self.content addLinkToURL:[NSURL URLWithString:tagStr] withRange:result.range];
    }
    self.content.adjustsFontSizeToFitWidth = YES;
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSString *tagUrl = [[url absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *tag = [tagUrl substringFromIndex:14];
    SearchViewController * searchVC = [[SearchViewController alloc] init];
    searchVC.index = 0;
    searchVC.keyword = tag;
    searchVC.evtType = @"tag";
    [self.nav pushViewController:searchVC animated:YES];
}

#pragma mark - setUI
- (void)setCellUI {
    [self addSubview:self.graybackView];
    [_graybackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.top.equalTo(self.mas_top).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
    
    [self addSubview:self.content];
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_graybackView.mas_left).with.offset(10);
        make.right.equalTo(_graybackView.mas_right).with.offset(-10);
        make.top.equalTo(_graybackView.mas_top).with.offset(5);
        make.bottom.equalTo(_graybackView.mas_bottom).with.offset(0);
    }];
    
//    [self addSubview:self.moreIcon];
//    [_moreIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(11, 11));
//        make.right.equalTo(_content.mas_right).with.offset(0);
//        make.bottom.equalTo(_content.mas_bottom).with.offset(-8);
//    }];
}

#pragma mark - init
- (UIView *)graybackView {
    if (!_graybackView) {
        _graybackView = [[UIView alloc] init];
        _graybackView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    }
    return _graybackView;
}

- (TTTAttributedLabel *)content {
    if (!_content) {
        _content = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _content.numberOfLines = 0;
        _content.delegate = self;
        _content.enabledTextCheckingTypes = NSTextCheckingTypeLink;
        _content.font = [UIFont systemFontOfSize:12];
        NSDictionary *linkAttributes = @{(NSString *)kCTUnderlineStyleAttributeName:[NSNumber numberWithBool:NO],
                                        (NSString *)kCTForegroundColorAttributeName:(__bridge id)[UIColor colorWithHexString:MAIN_COLOR].CGColor
                                         };
        _content.linkAttributes = linkAttributes;
        NSDictionary *activelinkAttributes = @{(NSString *)kCTUnderlineStyleAttributeName:[NSNumber numberWithBool:NO],
                                         (NSString *)kCTForegroundColorAttributeName:(__bridge id)[UIColor colorWithHexString:MAIN_COLOR].CGColor
                                         };
        _content.activeLinkAttributes = activelinkAttributes;
        NSDictionary *inactiveLinkAttributes = @{(NSString *)kCTUnderlineStyleAttributeName:[NSNumber numberWithBool:NO],
                                               (NSString *)kCTForegroundColorAttributeName:(__bridge id)[UIColor colorWithHexString:@"#666666"].CGColor
                                               };
        _content.inactiveLinkAttributes = inactiveLinkAttributes;
        _content.adjustsFontSizeToFitWidth = YES;
    }
    return _content;
}

- (UIButton *)moreIcon {
    if (!_moreIcon) {
        _moreIcon = [[UIButton alloc] init];
        [_moreIcon setImage:[UIImage imageNamed:@"shouye_jiahao"] forState:(UIControlStateNormal)];
    }
    return _moreIcon;
}

- (CGSize)getTextFrame:(NSString *)text {
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 50, 0)
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading |
                      NSStringDrawingUsesDeviceMetrics
                                          attributes:attribute
                                             context:nil].size;
    return textSize;
}

@end
