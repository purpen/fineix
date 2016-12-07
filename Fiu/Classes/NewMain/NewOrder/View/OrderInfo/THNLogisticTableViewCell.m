//
//  THNLogisticTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2016/12/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNLogisticTableViewCell.h"
//#import <QuartzCore/QuartzCore.h>

@implementation THNLogisticTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self set_cellViewUI];
    }
    return self;
}

- (void)thn_setLogisticData:(NSDictionary *)dict index:(NSInteger)index {
    NSString *timeStr = [dict valueForKey:@"AcceptTime"];
    NSString *stationStr = [dict valueForKey:@"AcceptStation"];
    
    self.timeLab.text = timeStr;
    self.stationLab.text = stationStr;
    
    if (index == 0) {
        self.timeLab.textColor = [UIColor colorWithHexString:MAIN_COLOR];
        self.stationLab.textColor = [UIColor colorWithHexString:MAIN_COLOR];
        self.lineBall.layer.borderWidth = 1.0f;
        self.lineBall.layer.borderColor = [UIColor colorWithHexString:MAIN_COLOR].CGColor;
        self.lineBall.backgroundColor = [UIColor whiteColor];
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect { // 可以通过 setNeedsDisplay 方法调用 drawRect:
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    // 设置线条的样式
    CGContextSetLineCap(context, kCGLineCapRound);
    
    // 绘制线的宽度
    CGContextSetLineWidth(context, 1.0);
    
    // 线的颜色
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:MAIN_COLOR].CGColor);
    
    // 开始绘制
    CGContextBeginPath(context);
    
    // 设置虚线绘制起点
    CGContextMoveToPoint(context, 30, 1);
    
    // lengths的值｛10,10｝表示先绘制10个点，再跳过10个点，如此反复
    CGFloat lengths[] = {2, 2};
    
    // 虚线的起始点
    CGContextSetLineDash(context, 0, lengths, 2);
    
    // 绘制虚线的终点
    CGContextAddLineToPoint(context, 30, CGRectGetMaxY(self.bounds));
    
    // 绘制
    CGContextStrokePath(context);
    
    // 关闭图像
    CGContextClosePath(context);
}



- (void)set_cellViewUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.timeLab];
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@12);
        make.left.equalTo(self.mas_left).with.offset(50);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.top.equalTo(self.mas_top).with.offset(15);
    }];
    
    [self addSubview:self.stationLab];
    [_stationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(50);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.top.equalTo(_timeLab.mas_bottom).with.offset(10);
        make.bottom.equalTo(self.mas_bottom).with.offset(-15);
    }];
    
    [self addSubview:self.lineBall];
    
    UILabel *bottomLab = [[UILabel alloc] init];
    bottomLab.backgroundColor = [UIColor colorWithHexString:@"#E5E5E5"];
    [self addSubview:bottomLab];
    [bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 50, 0.5));
        make.left.equalTo(self.mas_left).with.offset(50);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = [UIFont systemFontOfSize:12];
        _timeLab.textColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _timeLab;
}

- (UILabel *)stationLab {
    if (!_stationLab) {
        _stationLab = [[UILabel alloc] init];
        _stationLab.textColor = [UIColor colorWithHexString:@"#666666"];
        _stationLab.numberOfLines = 0;
        if (IS_iOS9) {
            _stationLab.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
        } else {
            _stationLab.font = [UIFont systemFontOfSize:13];
        }
    }
    return _stationLab;
}
- (UILabel *)lineBall {
    if (!_lineBall) {
        _lineBall = [[UILabel alloc] initWithFrame:CGRectMake(25, 16, 10, 10)];
        _lineBall.backgroundColor = [UIColor colorWithHexString:MAIN_COLOR];
        _lineBall.layer.cornerRadius = 10/2;
        _lineBall.layer.masksToBounds = YES;
    }
    return _lineBall;
}

@end
