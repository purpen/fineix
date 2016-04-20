//
//  FriendTableViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/4/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FriendTableViewCell.h"
#import "Fiu.h"
#import "FriendCollectionViewCell.h"

@interface FriendTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation FriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setUI{
    self.headImageView.image = [UIImage imageNamed:@""];
    self.nameLbael.text = @"boc 747";
    self.deressLabel.text = @"北京 朝阳区";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(32/667.0*SCREEN_HEIGHT, 32/667.0*SCREEN_HEIGHT));
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(self.mas_left).with.offset(15/667.0*SCREEN_HEIGHT);
        }];
        
        [self.contentView addSubview:self.nameLbael];
        [_nameLbael mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImageView.mas_right).with.offset(9/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(self.mas_top).with.offset(13/667.0*SCREEN_HEIGHT);
            make.height.mas_equalTo(12);
            make.right.mas_equalTo(self.mas_right).with.offset(-30);
        }];
        
        [self.contentView addSubview:self.mapImageView];
        [_mapImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(7/667.0*SCREEN_HEIGHT, 11/667.0*SCREEN_HEIGHT));
            make.left.mas_equalTo(_headImageView.mas_right).with.offset(9/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(_nameLbael.mas_bottom).with.offset(4/667.0*SCREEN_HEIGHT);
        }];
        
        [self.contentView addSubview:self.focusBtn];
        [_focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(72/667.0*SCREEN_HEIGHT, 26/667.0*SCREEN_HEIGHT));
            make.centerY.mas_equalTo(self.mas_centerY);
            make.right.mas_equalTo(self.mas_right).with.offset(15/667.0*SCREEN_HEIGHT);
        }];
        
        [self.contentView addSubview:self.imageCollectionView];
        [_imageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).with.offset(0);
            make.bottom.mas_equalTo(self.mas_bottom).with.offset(0);
            make.top.mas_equalTo(_headImageView.mas_bottom).with.offset(11/667.0*SCREEN_HEIGHT);
            make.right.mas_equalTo(self.mas_right).with.offset(0);
        }];
    }
    return self;
}

-(UICollectionView *)imageCollectionView{
    if (!_imageCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _imageCollectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
        _imageCollectionView.delegate = self;
        _imageCollectionView.dataSource = self;
        [_imageCollectionView registerClass:[FriendCollectionViewCell class] forCellWithReuseIdentifier:@"FriendCollectionViewCell"];
    }
    return _imageCollectionView;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"FriendCollectionViewCell";
    FriendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    [cell setUI];
    return cell;
}

-(UIButton *)focusBtn{
    if (!_focusBtn) {
        _focusBtn = [[UIButton alloc] init];
        [_focusBtn setImage:[UIImage imageNamed:@"focusOn"] forState:UIControlStateNormal];
        [_focusBtn setImage:[UIImage imageNamed:@"hasBeenFocusedOn"] forState:UIControlStateSelected];
    }
    return _focusBtn;
}

-(UIImageView *)mapImageView{
    if (!_mapImageView) {
        _mapImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_city"]];
    }
    return _mapImageView;
}

-(UILabel *)nameLbael{
    if (!_nameLbael) {
        _nameLbael = [[UILabel alloc] init];
        _nameLbael.font = [UIFont systemFontOfSize:11];
    }
    return _nameLbael;
}

-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = 16/667.0*SCREEN_HEIGHT;
    }
    return _headImageView;
}

@end
