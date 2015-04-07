//
//  CCCustomAnimator.m
//  iOS7TransitionDemo
//
//  Created by 陈爱彬 on 15/4/3.
//  Copyright (c) 2015年 陈爱彬. All rights reserved.
//

#import "CCCustomAnimator.h"

@interface CCCustomAnimator()
<UIViewControllerAnimatedTransitioning>

@property (nonatomic,assign) CCAnimationType animationType;
@property (nonatomic) BOOL interacting;
@property (nonatomic,strong) UIPercentDrivenInteractiveTransition *interactiveTransition;

@end

@implementation CCCustomAnimator

- (void)setPresentingVC:(UIViewController *)presentingVC
{
    _presentingVC = presentingVC;
    //添加手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_presentingVC.view addGestureRecognizer:panGesture];
}
#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    if (self.animationType == CCAnimationTypePresent) {
        /*弹出动画*/
        
        UIView *containerView = [transitionContext containerView];
        
        UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        CGRect boundsRect = [[UIScreen mainScreen] bounds];
        CGRect finalFrame = [transitionContext finalFrameForViewController:toVc];
        toVc.view.frame = CGRectOffset(finalFrame, 0, boundsRect.size.height);
        
        [containerView addSubview:toVc.view];
        
        NSTimeInterval interval = [self transitionDuration:transitionContext];
        [UIView animateWithDuration:interval delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
            toVc.view.frame = finalFrame;
        }completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }else if (self.animationType == CCAnimationTypeDismiss) {
        /*消失动画*/
        UIView *containerView = [transitionContext containerView];
        
        UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        [containerView insertSubview:toVc.view belowSubview:fromVc.view];
        CGRect boundsRect = [[UIScreen mainScreen] bounds];
        CGRect originFrame = [transitionContext initialFrameForViewController:fromVc];
        CGRect finalFrame = CGRectOffset(originFrame, 0, boundsRect.size.height);
        
        NSTimeInterval interval = [self transitionDuration:transitionContext];
        [UIView animateWithDuration:interval delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            fromVc.view.alpha = 0.f;
            fromVc.view.frame = finalFrame;
        }completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}
#pragma mark - UIPanGestureRecognizer Handler
- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    CGPoint tranlation = [gesture translationInView:_presentingVC.view];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.interacting = YES;
            self.interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
            [_presentingVC dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGFloat percent = tranlation.y / CGRectGetHeight(_presentingVC.view.frame);
            percent = MIN(MAX(0.0, percent), 1.0);
            [self.interactiveTransition updateInteractiveTransition:percent];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            self.interacting = NO;
            if (tranlation.y > 200) {
                [self.interactiveTransition finishInteractiveTransition];
            }else{
                [self.interactiveTransition cancelInteractiveTransition];
            }
            self.interactiveTransition = nil;
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.animationType = CCAnimationTypePresent;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.animationType = CCAnimationTypeDismiss;
    return self;
}
- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return self.interacting ? self.interactiveTransition : nil;
}

@end
