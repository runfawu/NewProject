//
//  GestureLockView.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-25.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "GestureLockView.h"

@implementation GestureLockView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.lockView.normalGestureNodeImage = [UIImage imageNamed:@"dot_off"];
    self.lockView.selectedGestureNodeImage = [UIImage imageNamed:@"dot_on"];
    self.lockView.lineColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
    self.lockView.lineWidth = 10;
    self.lockView.delegate = self;
    self.lockView.contentInsets = UIEdgeInsetsMake(0, 40, 0, 40); //上左下右
}

+ (GestureLockView *)loadNibInstance
{
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"GestureLockView" owner:self options:nil];
    GestureLockView *instance = nibArray[0];
    
    
    return instance;
}

- (void)gestureLockView:(KKGestureLockView *)gestureLockView didBeginWithPasscode:(NSString *)passcode{

}

- (void)gestureLockView:(KKGestureLockView *)gestureLockView didEndWithPasscode:(NSString *)passcode{
    NSLog(@"%@",passcode);
    
    [self removeFromSuperview];
   
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
