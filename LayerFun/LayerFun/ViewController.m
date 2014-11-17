//
//  ViewController.m
//  LayerFun
//
//  Created by cheshire on 14/11/14.
//  Copyright (c) 2014年 cheshire. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.layer.backgroundColor = [[UIColor orangeColor] CGColor];
    self.view.layer.cornerRadius = 20.0f;
    self.view.layer.frame = CGRectInset(self.view.layer.frame, 20,20);
    CALayer *subLayer = [CALayer layer];
    subLayer.backgroundColor = [UIColor blueColor].CGColor;
    subLayer.shadowOffset = CGSizeMake(0, 3);
    subLayer.shadowRadius = 5.0f;
    subLayer.shadowColor = [UIColor blackColor].CGColor;
    subLayer.shadowOpacity = 0.8f;
    subLayer.frame = CGRectMake(30, 30, 128, 192);
//    subLayer.contents = (id)[UIImage imageNamed:@"BattleMapSplashScreen.jpg"].CGImage;
    subLayer.borderColor = [UIColor blackColor].CGColor;
    subLayer.borderWidth = 2.0f;
    subLayer.cornerRadius = 10.0f;//not work if the content is a UIImage
    //work around #1
    //subLayer.masksToBounds = YES; //the shadow won't show up. they'll be masked out.
    //another workaround create two layers. the out layer do the shadow thing  and the inner layer carrys the image content.
    
    [self.view.layer addSublayer:subLayer];
    
    CALayer *imgLayer = [CALayer layer];
    imgLayer.frame = subLayer.bounds;
    imgLayer.cornerRadius = 10.0f;
    imgLayer.contents = (id)[UIImage imageNamed:@"BattleMapSplashScreen.jpg"].CGImage;
    imgLayer.masksToBounds = YES;
    [subLayer addSublayer:imgLayer];
    
    CALayer *customDrawn = [CALayer layer];
    customDrawn.delegate = self;
    customDrawn.backgroundColor = [UIColor greenColor].CGColor;
    customDrawn.frame = CGRectMake(30, 250, 128, 40);
    customDrawn.shadowOffset = CGSizeMake(0, 3);
    customDrawn.shadowRadius = 5.0;
    customDrawn.shadowColor = [UIColor blackColor].CGColor;
    customDrawn.shadowOpacity = 0.8;
    customDrawn.cornerRadius = 10.0;
    customDrawn.borderColor = [UIColor blackColor].CGColor;
    customDrawn.borderWidth = 2.0;
    customDrawn.masksToBounds = YES;
    [self.view.layer addSublayer:customDrawn];
    [customDrawn setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

void MyDrawColoredPattern (void *info, CGContextRef context) {
    
    CGColorRef dotColor = [UIColor colorWithHue:0 saturation:0 brightness:0.07 alpha:1.0].CGColor;
    CGColorRef shadowColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1].CGColor;
    
    CGContextSetFillColorWithColor(context, dotColor);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 1), 1, shadowColor);
    
    CGContextAddArc(context, 3, 3, 4, 0, 360, 0);
    CGContextFillPath(context);
    
    CGContextAddArc(context, 16, 16, 4, 0, 360, 0);
    CGContextFillPath(context);
    
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context {
    
    CGColorRef bgColor = [UIColor colorWithHue:0.6 saturation:1.0 brightness:1.0 alpha:1.0].CGColor;
    CGContextSetFillColorWithColor(context, bgColor);
    CGContextFillRect(context, layer.bounds);
    
    static const CGPatternCallbacks callbacks = { 0, &MyDrawColoredPattern, NULL };
    
    CGContextSaveGState(context);
    CGColorSpaceRef patternSpace = CGColorSpaceCreatePattern(NULL);
    CGContextSetFillColorSpace(context, patternSpace);
    CGColorSpaceRelease(patternSpace);
    
    CGPatternRef pattern = CGPatternCreate(NULL,
                                           layer.bounds,
                                           CGAffineTransformIdentity,
                                           24,
                                           24,
                                           kCGPatternTilingConstantSpacing,
                                           true,
                                           &callbacks);
    CGFloat alpha = 1.0;
    CGContextSetFillPattern(context, pattern, &alpha);
    CGPatternRelease(pattern);
    CGContextFillRect(context, layer.bounds);
    CGContextRestoreGState(context);
}

@end
