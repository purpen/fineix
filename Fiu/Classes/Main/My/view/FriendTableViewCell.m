//
//  FriendTableViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/4/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FriendTableViewCell.h"
#import "Fiu.h"
#import "FiuSceneCollectionViewCell.h" 
#import "FiuSceneRow.h"
#import "FindSceneModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FriendTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation FriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setUI{
    self.headImageView.image = [UIImage imageNamed:@"user"];
    self.nameLbael.text = @"boc 747";
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
            make.top.mas_equalTo(self.mas_top).with.offset(12);
            make.left.mas_equalTo(self.mas_left).with.offset(15/667.0*SCREEN_HEIGHT);
        }];
        
        [self.contentView addSubview:self.nameLbael];
        [_nameLbael mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImageView.mas_right).with.offset(9/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(self.mas_top).with.offset(13/667.0*SCREEN_HEIGHT);
            make.height.mas_equalTo(12);
            make.right.mas_equalTo(self.mas_right).with.offset(-30);
        }];
        
        [self.contentView addSubview:self.idTagsImageView];
        [_idTagsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImageView.mas_right).with.offset(9/667.0*SCREEN_HEIGHT);
            make.top.mas_equalTo(_nameLbael.mas_bottom).with.offset(4/667.0*SCREEN_HEIGHT);
        }];
        
        [self.contentView addSubview:self.focusBtn];
        [_focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(72/667.0*SCREEN_HEIGHT, 26/667.0*SCREEN_HEIGHT));
            make.centerY.mas_equalTo(_headImageView.mas_centerY);
            make.right.mas_equalTo(self.mas_right).with.offset(-15/667.0*SCREEN_HEIGHT);
        }];
        
        [self.contentView addSubview:self.imageCollectionView];
        [_imageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).with.offset(0);
            make.bottom.mas_equalTo(self.mas_bottom).with.offset(0);
            make.top.mas_equalTo(_headImageView.mas_bottom).with.offset(11/667.0*SCREEN_HEIGHT);
            make.right.mas_equalTo(self.mas_right).with.offset(0);
        }];
        
        [self.contentView addSubview:self.levelLabel];
        [_levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nameLbael.mas_bottom).with.offset(3);
            make.left.mas_equalTo(_headImageView.mas_right).with.offset(9/667.0*SCREEN_HEIGHT);
            make.right.mas_equalTo(self.focusBtn.mas_left).with.offset(5);
            make.height.mas_equalTo(10);
        }];
        
        [self.contentView addSubview:self.userLevelLabel];
        [_userLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_idTagsImageView.mas_right).with.offset(2/667.0*SCREEN_HEIGHT);
            make.centerY.mas_equalTo(_idTagsImageView.mas_centerY);
        }];
    }
    return self;
}

-(UILabel *)levelLabel{
    if (!_levelLabel) {
        _levelLabel = [[UILabel alloc] init];
        _levelLabel.font = [UIFont systemFontOfSize:9];
        _levelLabel.textColor = [UIColor lightGrayColor];
    }
    return _levelLabel;
}

-(UILabel *)userLevelLabel{
    if (!_userLevelLabel) {
        _userLevelLabel = [[UILabel alloc] init];
        _userLevelLabel.font = [UIFont systemFontOfSize:9];
        _userLevelLabel.textColor = [UIColor lightGrayColor];
    }
    return _userLevelLabel;
}


-(UICollectionView *)imageCollectionView{
    if (!_imageCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((SCREEN_WIDTH-6)/3.0, 216/667.0*SCREEN_HEIGHT);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 5);
        layout.minimumLineSpacing = 3;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _imageCollectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
        _imageCollectionView.backgroundColor = [UIColor whiteColor];
        _imageCollectionView.showsHorizontalScrollIndicator = NO;
        _imageCollectionView.delegate = self;
        _imageCollectionView.dataSource = self;
        [_imageCollectionView registerClass:[FiuSceneCollectionViewCell class] forCellWithReuseIdentifier:@"FiuSceneCollectionViewCell"];
    }
    return _imageCollectionView;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.sceneAry.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"FiuSceneCollectionViewCell";
    FiuSceneCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    //[cell setUI];
    FindSceneModel *model = self.sceneAry[indexPath.section];
    FiuSceneRow *model1 = [[FiuSceneRow alloc] init];
    
    model1.title = model.title;
    model1.coverUrl = model.cober;
    model1.address = model.address;
    [cell setFiuSceneList:model1];
    
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

-(UIImageView *)idTagsImageView{
    if (!_idTagsImageView) {
        _idTagsImageView = [[UIImageView alloc] init];
    }
    return _idTagsImageView;
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
