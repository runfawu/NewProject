//
//  AppTitleCell.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-16.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "AppTitleCell.h"

@implementation AppTitleCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)changeArrowWithUp:(BOOL)up
{
    if (up) {
        [UIView animateWithDuration:0.25 animations:^{
            self.arrowImageView.transform = CGAffineTransformMakeRotation(0 * M_PI/180.0);
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.arrowImageView.transform = CGAffineTransformMakeRotation(179.999 * M_PI / 180.0);
        }];
    }
}

@end
