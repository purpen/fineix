//
//  AddContentView.m
//  Fiu
//
//  Created by FLYang on 16/7/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AddContentView.h"
#import "FBEditShareInfoViewController.h"
#import "UILable+Frame.h"

@interface AddContentView () {
    NSString *_titleStr;
    NSString *_suTitleStr;
    NSString *_actionTitle;
    UITapGestureRecognizer * _tap;
}

@end

@implementation AddContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setViewUI];
    }
    return self;
}

- (void)thn_getActionDataTitle:(NSString *)title {
    _actionTitle = title;
}

#pragma mark - 
- (void)setViewUI {
    [self addSubview:self.sceneImgView];
    [_sceneImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH));
        make.top.left.equalTo(self).with.offset(0);
    }];
    
    [self addSubview:self.addText];
    [_addText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 25));
        make.left.equalTo(self.mas_left).with.offset(0);
        make.bottom.equalTo(_sceneImgView.mas_bottom).with.offset(-20);
    }];
    
    [self addSubview:self.contentRoll];
    [_contentRoll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 88));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.top.equalTo(_sceneImgView.mas_bottom).with.offset(0);
    }];
    
    [self.contentRoll addSubview:self.content];
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 78));
        make.left.equalTo(_contentRoll.mas_left).with.offset(0);
        make.top.equalTo(_contentRoll.mas_top).with.offset(5);
    }];
    
    [self addSubview:self.suTitle];
    [_suTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 25));
        make.left.equalTo(self.mas_left).with.offset(0);
        make.bottom.equalTo(_sceneImgView.mas_bottom).with.offset(-20);
    }];
    
    [self addSubview:self.title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 25));
        make.left.equalTo(self.mas_left).with.offset(0);
        make.bottom.equalTo(_sceneImgView.mas_bottom).with.offset(-20);
    }];
}

#pragma mark - 情景图片
- (UIImageView *)sceneImgView {
    if (!_sceneImgView) {
        _sceneImgView = [[UIImageView alloc] init];
        _sceneImgView.contentMode = UIViewContentModeScaleAspectFill;
        _sceneImgView.clipsToBounds = YES;
    }
    return _sceneImgView;
}

#pragma mark - 添加标题按钮
- (UIButton *)addText {
    if (!_addText) {
        _addText = [[UIButton alloc] init];
        _addText.titleLabel.font = [UIFont systemFontOfSize:17];
        [_addText setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_addText setTitle:NSLocalizedString(@"addText", nil) forState:(UIControlStateNormal)];
        _addText.backgroundColor = [UIColor colorWithHexString:BLACK_COLOR];
        [_addText addTarget:self action:@selector(goChooseText) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addText;
}

- (void)goChooseText {
    FBEditShareInfoViewController *chooseTextVC = [[FBEditShareInfoViewController alloc] init];
    NSString *title = [self.title.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *suTitle = [self.suTitle.text stringByReplacingOccurrencesOfString:@" " withString:@""];;
    if (title.length == 0) {
        title = @"";
    }
    if (suTitle.length == 0) {
        suTitle = @"";
    }
    chooseTextVC.titleText.text = [NSString stringWithFormat:@"%@%@", title, suTitle];
    chooseTextVC.desText.text = self.content.text;
    chooseTextVC.actionTitle = _actionTitle;
    chooseTextVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self.vc presentViewController:chooseTextVC animated:YES completion:^{
        chooseTextVC.getEdtiShareText = ^ (NSString *title, NSString *des, NSMutableArray *tagS) {
            [self thn_setSceneTitle:title];
            [self getContentWithTags:des];
            [self.content resignFirstResponder];
            self.userAddTags = tagS;
        };
    }];
}

- (void)thn_setSceneTitle:(NSString *)title {
    if (title.length > 20) {
        title = [title substringToIndex:20];
    }
    self.suTitle.text = @"";
    if (title.length == 0) {
        self.title.hidden = YES;
        self.suTitle.hidden = YES;
        self.addText.hidden = NO;
        self.title.text = title;
        
    } else if (title.length > 10) {
        self.title.hidden = NO;
        self.suTitle.hidden = NO;
        self.addText.hidden = YES;
        
        NSString * titleStr = [NSString stringWithFormat:@"    %@  ", [title substringToIndex:10]];
        self.title.text = titleStr;
        
        NSString * suTitleStr = [NSString stringWithFormat:@"    %@  ", [title substringFromIndex:10]];
        self.suTitle.text = suTitleStr;
        
        [self.suTitle mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([self getTitleSizeWidth:suTitleStr].width));
        }];
        
        [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([self getTitleSizeWidth:titleStr].width));
            make.bottom.equalTo(_sceneImgView.mas_bottom).with.offset(-48);
        }];
        
        [self layoutIfNeeded];
        
    } else if (title.length <= 10) {
        self.title.hidden = NO;
        self.suTitle.hidden = YES;
        self.addText.hidden = YES;
        NSString * str = [NSString stringWithFormat:@"    %@  ", title];
        self.title.text = str;
        [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([self getTitleSizeWidth:str].width));
            make.bottom.equalTo(_sceneImgView.mas_bottom).with.offset(-20);
        }];
        
        [self layoutIfNeeded];
    }
}

- (CGSize)getTitleSizeWidth:(NSString *)text {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
    
    CGSize retSize = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 0)
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    return retSize;
}

#pragma mark - 标题
- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.backgroundColor = [UIColor colorWithHexString:BLACK_COLOR];
        _title.textColor = [UIColor colorWithHexString:WHITE_COLOR];
        _title.font = [UIFont systemFontOfSize:17];
        _title.hidden = YES;
        _title.userInteractionEnabled = YES;
        UITapGestureRecognizer *titleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goChooseText)];
        [_title addGestureRecognizer:titleTap];
    }
    return _title;
}

- (UILabel *)suTitle {
    if (!_suTitle) {
        _suTitle = [[UILabel alloc] init];
        _suTitle.backgroundColor = [UIColor colorWithHexString:BLACK_COLOR];
        _suTitle.textColor = [UIColor colorWithHexString:WHITE_COLOR];
        _suTitle.font = [UIFont systemFontOfSize:17];
        _suTitle.hidden = YES;
        _suTitle.userInteractionEnabled = YES;
        UITapGestureRecognizer *titleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goChooseText)];
        [_suTitle addGestureRecognizer:titleTap];
    }
    return _suTitle;
}

#pragma mark - 描述
- (UIScrollView *)contentRoll {
    if (!_contentRoll) {
        _contentRoll = [[UIScrollView alloc] init];
        _contentRoll.showsVerticalScrollIndicator = NO;
        UITapGestureRecognizer *openTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goChooseText)];
        [_contentRoll addGestureRecognizer:openTap];
    }
    return _contentRoll;
}

- (TTTAttributedLabel *)content {
    if (!_content) {
        _content = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _content.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"addDescription", nil)
                                                                      attributes:@{(NSString *)kCTForegroundColorAttributeName:(__bridge id)[UIColor colorWithHexString:@"#333333"].CGColor,
                                                                                   NSFontAttributeName:[UIFont systemFontOfSize:12]}];

        _content.numberOfLines = 0;
        _content.delegate = self;
        _content.exclusiveTouch = NO;
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
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goChooseText)];
        [_content addGestureRecognizer:_tap];
    }
    return _content;
}

//  检索描述内容中的标签
- (void)getContentWithTags:(NSString *)content {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0f;
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
    
    CGSize size = [self.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 0)];
    [self.content mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(size.height * 1.5));
    }];
    self.contentRoll.contentSize = CGSizeMake(0, size.height *1.5);
}

@end
