//
//  TradeCell.h
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-17.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TradeObject.h"


@interface TradeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;
@property (weak, nonatomic) IBOutlet UILabel *orderidLabel;
@property (weak, nonatomic) IBOutlet UILabel *realpriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *supp_accnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeTime;
@property (weak, nonatomic) IBOutlet UIButton *statusnameButton;

@property (nonatomic, strong) TradeObject *tradeObj;

@end
