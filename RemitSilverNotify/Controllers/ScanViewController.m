//
//  ScanViewController.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-22.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "ScanViewController.h"
@import AVFoundation;
#import "AppWebController.h"
#import "QRDetailController.h"

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
}

@property (strong,nonatomic)AVCaptureDevice *device;
@property (strong,nonatomic)AVCaptureDeviceInput *input;
@property (strong,nonatomic)AVCaptureMetadataOutput *output;
@property (strong,nonatomic)AVCaptureSession *session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer *preview;
@property (nonatomic, retain) UIImageView *line;

@end

@implementation ScanViewController


- (void)dealloc
{
    DLog(@"scan dealloc");
}
- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.showNavi = YES;
        self.enableBack = YES;
        self.title = @"二维码扫描";
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    DLog(@"scan view frame = %@", NSStringFromCGRect(self.view.frame));
    DLog(@"scam view center = %@", NSStringFromCGPoint(self.view.center));
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(3, 20, SCREEN_WIDTH, 20)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.textColor=[UIColor blackColor];
    labIntroudction.text=@"将二维码图像置于框内，即可自动扫描。";
    labIntroudction.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labIntroudction];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 280/2,SCREEN_HEIGHT/2 - 280/2 - 20, 280, 280)];
    imageView.image = [UIImage imageNamed:@"scan_bg"];
    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 220/2, SCREEN_HEIGHT/2 - 280/2 - 20, 220, 2)];
    _line.image = [UIImage imageNamed:@"scan_line"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupCamera];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    DLog(@"scan frame = %@", NSStringFromCGRect(self.view.frame));
}

#pragma mark - Private methods
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(SCREEN_WIDTH/2 - 220/2, SCREEN_HEIGHT/2 - 280/2 - 20 + 2*num, 220, 2);
        if (2*num == 280) {
            upOrdown = YES;
        }
    } else {
        num --;
        _line.frame = CGRectMake(SCREEN_WIDTH/2 - 220/2, SCREEN_HEIGHT/2 - 280/2 - 20 + 2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}

- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =CGRectMake(SCREEN_WIDTH/2 - 280/2,SCREEN_HEIGHT/2 - 280/2 - 20, 280, 280);
    
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    
    
    // Start
    [_session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue = @"";
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    [timer invalidate];
    DLog(@"二维码为：%@",stringValue);
    
    if ([stringValue hasPrefix:@"http://"]) {
//        AppWebController *webController = [[AppWebController alloc] initWithNibName:@"AppWebController" bundle:nil];
//        webController.urlString = stringValue;
//        
//        [self.navigationController pushViewController:webController animated:YES];
        QRDetailController *detailController = [[QRDetailController alloc] initWithNibName:@"QRDetailController" bundle:nil];
        detailController.URLString = stringValue;
        
        [self.navigationController pushViewController:detailController animated:YES];
    }
}

#pragma mark - Override
- (void)clickBack:(id)sender
{
    [timer invalidate];
    timer = nil;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
