//
//  SortedAppCell.h
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-12.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppObject.h"

@interface SortedAppCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *sortLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;
@property (weak, nonatomic) IBOutlet UIImageView *checkMarkImageView;

@property (nonatomic, strong) AppObject *appObj;

@end
