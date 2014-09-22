//
//  VPImageCropperViewController.h
//  VPolor
//
//  Created by Vinson.D.Warm on 12/30/13.
//  Copyright (c) 2013 Huang Vinson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageCropController;

@protocol ImageCropDelegate <NSObject>

- (void)imageCrop:(ImageCropController *)cropController didFinished:(UIImage *)editedImage;
- (void)imageCropDidCancel:(ImageCropController *)cropController;

@end



@interface ImageCropController : UIViewController

@property (nonatomic, assign) id<ImageCropDelegate> delegate;

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;

@end
