//
//  NoDataCell.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-17.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "NoDataCell.h"

@implementation NoDataCell

- (void)awakeFromNib
{
    self.noDataView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
