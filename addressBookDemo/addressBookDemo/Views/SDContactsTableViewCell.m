//
//  SDContactsTableViewCell.m
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/3/3.
//  Copyright © 2016年 GSD. All rights reserved.
//


#import "SDContactsTableViewCell.h"
#import "UIView+SDAutoLayout.h"
#import "SDContactModel.h"

@implementation SDContactsTableViewCell
{
    UIImageView *_iconImageView;
    UILabel *_nameLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 这行代是为了解决tableview开启了字母序列索引之后cell会向左缩进一段距离的问题
        self.contentView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        
        [self setupView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    frame.size.width = 375;
    [super setFrame:frame];
}

- (void)setupView
{
    _iconImageView = [UIImageView new];
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1.0]CGColor];
    _iconImageView.layer.borderWidth = 0.5;
    [self.contentView addSubview:_iconImageView];
    
    _nameLabel = [UILabel new];
    _nameLabel.textColor = [UIColor darkGrayColor];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_nameLabel];
    
    
    CGFloat margin = 8;
    
    _iconImageView.sd_layout
    .leftSpaceToView(self.contentView, margin)
    .widthIs(HEIGHTFORCONTACTSCELL-margin*2.5)
    .heightEqualToWidth()
    .centerYEqualToView(self.contentView);
    
    _nameLabel.sd_layout
    .leftSpaceToView(_iconImageView, margin)
    .centerYEqualToView(_iconImageView)
    .rightSpaceToView(self.contentView, margin)
    .heightIs(30);
    
}

- (void)setModel:(SDContactModel *)model
{
    _model = model;
    
    _nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    _iconImageView.image = [UIImage imageNamed:model.imageName];
}

+ (CGFloat)fixedHeight
{
    return 50;
}

@end
