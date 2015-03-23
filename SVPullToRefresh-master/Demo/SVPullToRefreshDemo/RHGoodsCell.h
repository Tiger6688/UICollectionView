//
//  LSGoodsCell.h
//  SpiritTrack
//
//  Created by apple on 15/1/23.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RHGoodsCellDelegate <NSObject>
@required

- (void)deleteAction:(id)sender;

@end

@interface RHGoodsCell: UICollectionViewCell

+(NSString*)cellIdentifier;
+(id)loadFromXib;

@property (nonatomic, assign) id <RHGoodsCellDelegate> delegate;

@property (strong,nonatomic)IBOutlet UIButton *deleteBtn;
@property (strong,nonatomic)IBOutlet UIView *baseView;

@end
