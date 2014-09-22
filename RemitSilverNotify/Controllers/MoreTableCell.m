//
//  MoreTableCell.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-18.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "MoreTableCell.h"

@implementation MoreTableCell

- (void)awakeFromNib
{
    self.moneyLabel.hidden = YES;
    self.thumbImageView.layer.cornerRadius = 5;
    self.thumbImageView.clipsToBounds = YES;
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
    bottomBorder.backgroundColor = [UIColor colorWithRed:38/255.0 green:146/255.0 blue:174/255.0 alpha:1].CGColor;
    
    [self.layer addSublayer:bottomBorder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];


}

@end
