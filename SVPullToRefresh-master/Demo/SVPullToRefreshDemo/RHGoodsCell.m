//
//  LSGoodsCell.m
//  SpiritTrack
//
//  Created by apple on 15/1/23.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "RHGoodsCell.h"

@implementation RHGoodsCell

+(NSString*)cellIdentifier
{
    return NSStringFromClass(self);
}
+(id)loadFromXib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil]lastObject];
}
+(CGSize)cellSize
{
    return CGSizeMake(100, 100);
}

- (IBAction)deleteAction:(id)sender {
    [_delegate deleteAction:sender];
}

- (void)dealloc
{
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    _baseView.backgroundColor = [UIColor lightGrayColor];
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
//    [titleLabel setText:@"收藏的商品"];
//    [_baseView addSubview:titleLabel];
//    [self.contentView addSubview:_baseView];
//    
//    _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    _deleteBtn.backgroundColor = [UIColor blueColor];
//    _deleteBtn.hidden = !_deleteBtn.hidden;
//    [_deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:_deleteBtn];
}


@end
