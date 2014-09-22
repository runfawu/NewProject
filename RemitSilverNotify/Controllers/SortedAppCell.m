//
//  SortedAppCell.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-12.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "SortedAppCell.h"

@implementation SortedAppCell

- (void)awakeFromNib
{
    self.lineImageView.hidden = YES;
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(70, self.frame.size.height - 1, self.frame.size.width - 70, 1);
    bottomBorder.backgroundColor = [UIColor colorWithRed:38/255.0 green:146/255.0 blue:174/255.0 alpha:1].CGColor;
    
    [self.layer addSublayer:bottomBorder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];


}

@end
