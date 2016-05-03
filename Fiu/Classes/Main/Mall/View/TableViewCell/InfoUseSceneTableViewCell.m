//
//  InfoUseSceneTableViewCell.m
//  Fiu
//
//  Created by FLYang on 16/4/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "InfoUseSceneTableViewCell.h"

static const NSInteger userSceneBtnTag = 435;

@implementation InfoUseSceneTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setCellUI];
        
    }
    return self;
}

- (void)setUI:(NSArray *)sceneArr {
    NSMutableArray * scene = [NSMutableArray arrayWithArray:sceneArr];
    [scene addObject:NSLocalizedString(@"lookMore", nil)];
    [self addUseSceneScrollView:scene];
    
}

#pragma mark -
- (void)setCellUI {
    [self addSubview:self.headerTitle];
    
    [self addSubview:self.line];
    
    [self addSubview:self.useSceneRollView];
}

#pragma mark - 标题
- (UILabel *)headerTitle {
    if (!_headerTitle) {
        _headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 44)];
        _headerTitle.text = NSLocalizedString(@"userSceneTitle", nil);
        _headerTitle.textColor = [UIColor colorWithHexString:@"#333333"];
        _headerTitle.font = [UIFont systemFontOfSize:Font_GoodsTitle];
    }
    return _headerTitle;
}

#pragma mark - 分割线
- (UILabel *)line {
    if (!_line) {
        _line = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 1)];
        _line.backgroundColor = [UIColor colorWithHexString:lineGrayColor];
    }
    return _line;
}

#pragma mark - 推荐场景
- (UIScrollView *)useSceneRollView {
    if (!_useSceneRollView) {
        _useSceneRollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 45)];
        _useSceneRollView.showsVerticalScrollIndicator = NO;
        _useSceneRollView.showsHorizontalScrollIndicator = NO;
    }
    return _useSceneRollView;
}

//  创建推荐的应用场景按钮
- (void)addUseSceneScrollView:(NSArray *)sceneMarr {
    
    CGFloat width = 0;
    CGFloat height = 8;
    
    for (NSUInteger idx = 0; idx < sceneMarr.count; ++ idx) {
        UIButton * sceneBtn = [[UIButton alloc] init];
        CGFloat btnLength = [[sceneMarr objectAtIndex:idx] boundingRectWithSize:CGSizeMake(320, 1000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:nil context:nil].size.width;
        [sceneBtn setTitle:sceneMarr[idx] forState:(UIControlStateNormal)];
        [sceneBtn setTitleColor:[UIColor colorWithHexString:fineixColor] forState:(UIControlStateNormal)];
        sceneBtn.titleLabel.font = [UIFont systemFontOfSize:Font_Tag];
        sceneBtn.layer.cornerRadius = 5;
        sceneBtn.layer.borderColor = [UIColor colorWithHexString:fineixColor].CGColor;
        sceneBtn.layer.borderWidth = 0.5f;
        sceneBtn.frame = CGRectMake(15 + width + (10 * idx), height, btnLength + 40, 29);
        width = sceneBtn.frame.size.width + width;
        sceneBtn.tag = userSceneBtnTag + idx;
        
        [self.useSceneRollView addSubview:sceneBtn];
    }
    
    self.useSceneRollView.contentSize = CGSizeMake(width + 70, 0);
}

@end
