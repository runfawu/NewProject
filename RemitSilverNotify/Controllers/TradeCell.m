//
//  TradeCell.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-17.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "TradeCell.h"

@implementation TradeCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0, 10, self.frame.size.width, 1);
    topBorder.backgroundColor = [UIColor colorWithRed:38/255.0 green:146/255.0 blue:174/255.0 alpha:0.7].CGColor;
    
    [self.layer addSublayer:topBorder];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
    bottomBorder.backgroundColor = [UIColor colorWithRed:38/255.0 green:146/255.0 blue:174/255.0 alpha:0.7].CGColor;
    
    [self.layer addSublayer:bottomBorder];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTradeObj:(TradeObject *)tradeObj
{
    _tradeObj = tradeObj;
    self.orderidLabel.text = _tradeObj.orderid;
    self.realpriceLabel.text = _tradeObj.realprice;
    self.supp_accnameLabel.text = _tradeObj.supp_accname;
    NSString *year = [_tradeObj.createdate substringToIndex:4];
    NSString *month = [_tradeObj.createdate substringWithRange:NSMakeRange(4, 2)];
    NSString *day = [_tradeObj.createdate substringFromIndex:6];
    NSString *hour = [_tradeObj.createtime substringToIndex:2];
    NSString *minute = [_tradeObj.createtime substringWithRange:NSMakeRange(2, 2)];
    NSString *second = [_tradeObj.createtime substringFromIndex:4];
    self.tradeTime.text = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@", year, month, day, hour, minute, second];
    if ([_tradeObj.statusname isEqualToString:@"等待付款"]) {
        self.statusnameButton.backgroundColor = [UIColor redColor];
        self.statusnameButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    } else {
        self.statusnameButton.backgroundColor = [UIColor clearColor];
        self.statusnameButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.statusnameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [self.statusnameButton setTitle:_tradeObj.statusname forState:UIControlStateNormal];
    
}


@end
