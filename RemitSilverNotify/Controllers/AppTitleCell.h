//
//  AppTitleCell.h
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-16.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppTitleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

- (void)changeArrowWithUp:(BOOL)up;

@end
