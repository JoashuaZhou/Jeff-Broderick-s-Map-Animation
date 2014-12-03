//
//  ViewController.m
//  Jeff Broderick’s Map Animation
//
//  Created by Joshua Zhou on 14/12/2.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "ViewController.h"
#import "JNWSpringAnimation.h"

typedef enum {
    AnimationTypeMapViewAppear,
    AnimationTypeMapViewDisappear
} AnimationType;

@interface ViewController ()

@property (nonatomic, weak) UIImageView *backgroundView;
@property (nonatomic, weak) UIButton *button;
@property (nonatomic, weak) UIImageView *mapView;

@end

@implementation ViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

- (void)setupUI
{
    /* 背景图 */
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app-bg"]];
    backgroundView.frame = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:backgroundView];
    self.backgroundView = backgroundView;
    
    /* 按钮 */
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.view.bounds.size.width - 44, 30, 30, 30);
    [button setImage:[UIImage imageNamed:@"map-icon"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickAnimationButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.button = button;
    
    /* 地图 */
    UIImageView *mapView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map-arrow"]];
    mapView.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.width / 600 * 916);
    mapView.alpha = 0;
    mapView.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.1, 1.1), CGAffineTransformMakeTranslation(0, 60));
    [self.view addSubview:mapView];
    self.mapView = mapView;
}

- (void)clickAnimationButton:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (!sender.selected) {
        
        /* 背景出现/消失部分 */
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.backgroundView.alpha = 1.0f;
        } completion:nil];
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.mapView.alpha = 0;
        } completion:nil];
        
        /* 放大/缩小动画 */
        [self addSpringAnimationWithLayer:self.backgroundView.layer keyPath:@"transform.scale" ToValue:1.0 AnimationType:AnimationTypeMapViewDisappear];
        [self addSpringAnimationWithLayer:self.mapView.layer keyPath:@"transform.scale" ToValue:1.1 AnimationType:AnimationTypeMapViewDisappear];
        [self addSpringAnimationWithLayer:self.mapView.layer keyPath:@"transform.translation.y" ToValue:60 AnimationType:AnimationTypeMapViewDisappear];
    } else {
        /* 背景出现/消失部分 */
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.mapView.alpha = 1.0f;
        } completion:nil];
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.backgroundView.alpha = 0.5f;
        } completion:nil];
        
        /* 放大/缩小动画 */
        [self addSpringAnimationWithLayer:self.backgroundView.layer keyPath:@"transform.scale" ToValue:0.9 AnimationType:AnimationTypeMapViewAppear];
        [self addSpringAnimationWithLayer:self.mapView.layer keyPath:@"transform.scale" ToValue:1.0 AnimationType:AnimationTypeMapViewAppear];
        [self addSpringAnimationWithLayer:self.mapView.layer keyPath:@"transform.translation.y" ToValue:0 AnimationType:AnimationTypeMapViewAppear];
    }
}

- (void)addSpringAnimationWithLayer:(CALayer *)layer keyPath:(NSString *)keyPath ToValue:(CGFloat)value AnimationType:(AnimationType)type
{
    JNWSpringAnimation *animation = [JNWSpringAnimation animationWithKeyPath:keyPath];
    animation.mass = 1.0f;
    
    if (type == AnimationTypeMapViewAppear) {
        animation.damping = 16.0f;
        animation.stiffness = 16.0f;
    } else {
        animation.damping = 24.0f;
        animation.stiffness = 24.0f;
    }
    
    animation.fromValue = @([[layer.presentationLayer valueForKeyPath:keyPath] floatValue]);
    animation.toValue = @(value);
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [layer addAnimation:animation forKey:keyPath];
}

@end
