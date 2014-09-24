//
//  SafetyCell.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-24.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "SafetyCell.h"

@implementation SafetyCell

- (void)awakeFromNib
{
    self.statusLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];


}

@end
