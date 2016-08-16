//
//  AddContentView.m
//  Fiu
//
//  Created by FLYang on 16/7/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AddContentView.h"
#import "FBEditShareInfoViewController.h"
#import "TagFlowLayout.h"
#import "ChooseTagsCollectionViewCell.h"

@interface AddContentView () {
    NSString *_titleStr;
    NSString *_suTitleStr;
    UITapGestureRecognizer * _tap;
}

@pro_strong TagFlowLayout * chooseFlowLayout;

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
    
    [self addSubview:self.content];
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 20, 88));
        make.left.equalTo(self.mas_left).with.offset(10);
        make.top.equalTo(_sceneImgView.mas_bottom).with.offset(0);
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
        _sceneImgView.image = self.bgImage;
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
    FBEditShareInfoViewController * chooseTextVC = [[FBEditShareInfoViewController alloc] init];
    if (self.title.text.length > 0) {
        chooseTextVC.titleText.text = [self.title.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        chooseTextVC.desText.text = self.content.text;
    }
    chooseTextVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self.vc presentViewController:chooseTextVC animated:YES completion:nil];
    
    chooseTextVC.getEdtiShareText = ^ (NSString * title, NSString * des, NSArray * tagS) {
        [self thn_setSceneTitle:title];
        self.content.text = des;
        [self.content resignFirstResponder];
    };
}

- (void)thn_setSceneTitle:(NSString *)title {
    if (title.length == 0) {
        self.title.hidden = YES;
        self.suTitle.hidden = YES;
        self.addText.hidden = NO;
        
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
        
    } else if (title.length < 10) {
        self.title.hidden = NO;
        self.suTitle.hidden = YES;
        self.addText.hidden = YES;
        NSString * str = [NSString stringWithFormat:@"    %@  ", title];
        self.title.text = str;
        [self.title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([self getTitleSizeWidth:str].width));
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
    }
    return _suTitle;
}

#pragma mark - 描述
- (UITextView *)content {
    if (!_content) {
        _content = [[UITextView alloc] init];
        _content.font = [UIFont systemFontOfSize:12];
        _content.text = NSLocalizedString(@"addDescription", nil);
        _content.textColor = [UIColor colorWithHexString:@"#333333"];
        _content.backgroundColor = [UIColor whiteColor];
        _content.delegate = self;
        _content.editable = NO;
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goChooseText)];
        [_content addGestureRecognizer:_tap];
    }
    return _content;
}

@end
