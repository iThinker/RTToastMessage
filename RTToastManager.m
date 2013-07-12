//
//  RTToastManager.m
//  RTToastManager
//
//  Created by Roman Temchenko on 7/8/13.
//  Copyright (c) 2013 Roman Temchenko. All rights reserved.
//

//  This code is distributed under the terms and conditions of the MIT license.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "RTToastManager.h"
#import "RTToastMessage.h"

#if __has_feature(objc_arc)
#define RT_AUTORELEASE(exp) exp
#define RT_RELEASE(exp)
#define RT_RETAIN(exp)
#else
#define RT_AUTORELEASE(exp) [exp autorelease]
#define RT_RELEASE(exp) [exp release]
#define RT_RETAIN(exp) [exp retain]
#endif

NSTimeInterval const RTToastShowAnimationDuration = 0.4;
NSTimeInterval const RTToastHideAnimationDuration = 0.4;
NSTimeInterval const RTToastTransisitionAnimationDuration = 0.4;

CGFloat const RTToastFrameTop = 20.0f;
CGFloat const RTToastFrameHeight = 68.0f;
CGFloat const RTToastMinFrameSide = 1.0f;
CGFloat const RTToastContentInset = 5.0f;

typedef void(^RTAnimationBlock)(UIView *oldView, UIView *newView);

@interface RTToastViewAnimator : NSObject

+ (BOOL)isTransitionSupportedByUIVIew:(RTToastMessageTransitionType)transitionType;
+ (RTAnimationBlock)preAnimationBlockForTransitionType:(RTToastMessageTransitionType)transitionType;
+ (RTAnimationBlock)animationBlockForTransitionType:(RTToastMessageTransitionType)transitionType;

@end

@implementation RTToastViewAnimator

+ (BOOL)isTransitionSupportedByUIVIew:(RTToastMessageTransitionType)transitionType {
    return !(transitionType == RTToastMessageTransitionMoveInFromTop || transitionType == RTToastMessageTransitionMoveInFromLeft || transitionType == RTToastMessageTransitionMoveInFromRight || transitionType == RTToastMessageTransitionMoveInFromBottom);
}

+ (RTAnimationBlock)preAnimationBlockForTransitionType:(RTToastMessageTransitionType)transitionType {
    RTAnimationBlock result = nil;
    switch (transitionType) {
        case RTToastMessageTransitionMoveInFromRight:
            result = ^(UIView *oldView, UIView *newView) {
                CGRect viewFrame = newView.frame;
                viewFrame.origin.x = CGRectGetMaxX(oldView.frame);
                newView.frame = viewFrame;
            };
            break;
        case RTToastMessageTransitionMoveInFromLeft:
            result = ^(UIView *oldView, UIView *newView) {
                CGRect viewFrame = newView.frame;
                viewFrame.origin.x = oldView.frame.origin.x - viewFrame.size.width;
                newView.frame = viewFrame;
            };
            break;
        case RTToastMessageTransitionMoveInFromTop:
            result = ^(UIView *oldView, UIView *newView) {
                CGRect viewFrame = newView.frame;
                viewFrame.origin.y = oldView.frame.origin.y - viewFrame.size.height;
                newView.frame = viewFrame;
            };
            break;
        case RTToastMessageTransitionMoveInFromBottom:
            result = ^(UIView *oldView, UIView *newView) {
                CGRect viewFrame = newView.frame;
                viewFrame.origin.y = CGRectGetMaxY(oldView.frame);
                newView.frame = viewFrame;
            };
            break;
        default:
            break;
    }
    return result;
}

+ (RTAnimationBlock)animationBlockForTransitionType:(RTToastMessageTransitionType)transitionType {
    RTAnimationBlock result = nil;
    switch (transitionType) {
        case RTToastMessageTransitionMoveInFromRight:
            result = ^(UIView *oldView, UIView *newView) {
                CGRect viewFrame = oldView.frame;
                newView.frame = viewFrame;
                viewFrame.origin.x -= viewFrame.size.width;
                oldView.frame = viewFrame;
            };
            break;
        case RTToastMessageTransitionMoveInFromLeft:
            result = ^(UIView *oldView, UIView *newView) {
                CGRect viewFrame = oldView.frame;
                newView.frame = viewFrame;
                viewFrame.origin.x = CGRectGetMaxX(viewFrame);
                oldView.frame = viewFrame;
            };
            break;
        case RTToastMessageTransitionMoveInFromTop:
            result = ^(UIView *oldView, UIView *newView) {
                CGRect viewFrame = oldView.frame;
                newView.frame = viewFrame;
                viewFrame.origin.y = CGRectGetMaxY(viewFrame);
                oldView.frame = viewFrame;
            };
            break;
        case RTToastMessageTransitionMoveInFromBottom:
            result = ^(UIView *oldView, UIView *newView) {
                CGRect viewFrame = oldView.frame;
                newView.frame = viewFrame;
                viewFrame.origin.y -= viewFrame.size.height;
                oldView.frame = viewFrame;
            };
            break;
        default:
            break;
    }
    return result;
}

@end

@interface RTToastBackgroundView : UIView
@end

@implementation RTToastBackgroundView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    __block BOOL result = NO;
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        result = [obj pointInside:[obj convertPoint:point fromView:self] withEvent:event];
        *stop = result;
    }];
    return result;
}

@end

@interface RTToastManager ()

@property (nonatomic, strong) RTToastMessage *currentMessage;

- (void)showInWindow:(UIWindow *)window;
- (void)hide;
- (BOOL)hasMessage;
- (RTToastMessage *)popNextMessage;
- (void)showNextMessage;
- (UIView *)viewForMessage:(RTToastMessage *)message withFrame:(CGRect)frame;
- (void)statusBarOrientationWillChange:(NSNotification *)notification;
- (void)setTransformForOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated;
- (void)singleTapAction:(id)sender;
- (void)doubleTapAction:(id)sender;

@end

@implementation RTToastManager

static RTToastManager* sharedToastManager;

+ (RTToastManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedToastManager = [[self alloc] initInWindow:[[UIApplication sharedApplication].delegate window]];
    });
    return sharedToastManager;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if !__has_feature(objc_arc)
    [_backgroundView release];
    [_toastView release];
    [_messageView release];
    [_messages release];
    [super dealloc];
#endif
}

- (id)initInWindow:(UIWindow *)aWindow {
    if (self = [super init]) {
        _window = aWindow;
        _messages = [[NSMutableArray alloc] initWithCapacity:5];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationWillChange:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    }
    return self;
}

- (void)showMessage:(RTToastMessage *)message {
    // we do not want to have multiple identical messages in the queue
    NSString *messageText = message.text;
    NSTimeInterval messageDuration = message.duration;
    if ([messageText isEqualToString:_currentMessage.text]) {
        if ([_hidingTimer isValid]) {
            [_hidingTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:messageDuration]];
        }
        else {
            _duration = message.duration;
        }
        return;
    }
    __block BOOL hasMessage = NO;
    [_messages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        RTToastMessage *lastMessage = obj;
        if ([messageText isEqualToString:lastMessage.text]) {
            lastMessage.duration = messageDuration;
            hasMessage = YES;
            *stop = YES;
        }
    }];
    if (hasMessage) {
        return;
    }
    
    BOOL messageQueueWasEmpty = ![self hasMessage];
    [_messages addObject:message];
    if (messageQueueWasEmpty) {
        [self showInWindow:_window];
    }
}

- (void)showMessageWithText:(NSString *)text {
    [self showMessageWithText:text duration:RTToastMessageDefaultDuration];
}

- (void)showMessageWithText:(NSString *)text duration:(NSTimeInterval)duration {
    RTToastMessage *message = RT_AUTORELEASE([[RTToastMessage alloc] initWithText:text andDuration:duration]);
    [self showMessage:message];
}

- (void)onHidingTimer:(NSTimer *)timer {
    if ([self hasMessage]) {
        [self showNextMessage];
    }
    else {
        [self hide];
    }
}

#pragma mark - Private methods

- (UIInterfaceOrientation)rootOrientation {
    return [UIApplication sharedApplication].statusBarOrientation;
}

- (void)showInWindow:(UIWindow *)window {
    if (!_toastView) {
        CGRect parentBounds = window.bounds;
        BOOL isPad = UIUserInterfaceIdiomPad == [UIDevice currentDevice].userInterfaceIdiom;
        CGFloat widthFactor = isPad ? 0.6f : 1.0f;
        CGFloat width = widthFactor * MIN(parentBounds.size.width, parentBounds.size.height);
        CGFloat parentWidth = parentBounds.size.width;
        
        _maxFrame = CGRectIntegral(CGRectMake((parentWidth - width) / 2, RTToastFrameTop, width, RTToastFrameHeight));
        _minFrame = CGRectIntegral(CGRectMake(_maxFrame.origin.x + (_maxFrame.size.width - RTToastMinFrameSide) / 2, _maxFrame.origin.y + (_maxFrame.size.height - RTToastMinFrameSide) / 2, RTToastMinFrameSide, RTToastMinFrameSide));
        
        _toastView = [[UIView alloc] initWithFrame:_minFrame];
        _toastView.backgroundColor = [UIColor clearColor];
        _toastView.contentMode = UIViewContentModeCenter;
        _toastView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        _toastView.clipsToBounds = YES;
        UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        singleTapGR.numberOfTapsRequired = 1;
        UITapGestureRecognizer *doubleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
        doubleTapGR.numberOfTapsRequired = 2;
        [singleTapGR requireGestureRecognizerToFail:doubleTapGR];
        [_toastView addGestureRecognizer:singleTapGR];
        [_toastView addGestureRecognizer:doubleTapGR];
        RT_RELEASE(singleTapGR);
        RT_RELEASE(doubleTapGR);
        
        _currentMessage = [self popNextMessage];
        RT_RETAIN(_currentMessage);
        CGRect messageFrame = _maxFrame;
        messageFrame.origin = CGPointMake(0.0f, 0.0f);
        _messageView = [self viewForMessage:_currentMessage withFrame:messageFrame];
        RT_RETAIN(_messageView);
        _messageView.frame = _toastView.bounds;
        [_toastView addSubview:_messageView];
        
        _backgroundView = [[RTToastBackgroundView alloc] initWithFrame:parentBounds];
        [_backgroundView addSubview:_toastView];
        
        [window addSubview:_backgroundView];
        [window bringSubviewToFront:_backgroundView];
        [self setTransformForOrientation:[self rootOrientation] animated:NO]; 
        [UIView animateWithDuration:RTToastShowAnimationDuration / 2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            // first: stretch horizontally
            CGRect toastBounds = _toastView.bounds;
            toastBounds.size.width = _maxFrame.size.width;
            _toastView.bounds = toastBounds;
        } completion:^(BOOL finished) {
            // second: unwrap vertically
            if (finished) {
                [UIView animateWithDuration:RTToastShowAnimationDuration / 2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    CGRect toastBounds = _toastView.bounds;
                    toastBounds.size.height = _maxFrame.size.height;
                    _toastView.bounds = toastBounds;
                } completion:^(BOOL finished) {
                    if (finished) {
                        // third: starting hide timer
                        _hidingTimer = [NSTimer timerWithTimeInterval:_currentMessage.duration target:self selector:@selector(onHidingTimer:) userInfo:nil repeats:NO];
                        RT_RETAIN(_hidingTimer);
                        [[NSRunLoop currentRunLoop] addTimer:_hidingTimer forMode:NSRunLoopCommonModes];
                    }
                }];
            }
        }];
    }
}

- (void)hide {
    [_hidingTimer invalidate];
    RT_RELEASE(_hidingTimer);
    _hidingTimer = nil;
    [_messages removeAllObjects];
    if (_toastView) {
        UIView *parent = _toastView.superview;
        [parent bringSubviewToFront:_toastView];
        UIView *oldBackgroundView = _backgroundView;
        _backgroundView = nil;
        UIView *oldToastView = _toastView;
        _toastView = nil;
        UIView *oldMessageView = _messageView;
        _messageView = nil;
        RT_RELEASE(_currentMessage);
        _currentMessage = nil;
        CGRect minFrame = _minFrame;
        [UIView animateWithDuration:RTToastHideAnimationDuration / 2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            // first: wrap vertically
            CGRect toastBounds = oldToastView.bounds;
            toastBounds.size.height = minFrame.size.height;
            oldToastView.bounds = toastBounds;
        } completion:^(BOOL finished) {
            // second: shrink horizontally
            [UIView animateWithDuration:RTToastHideAnimationDuration / 2 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                CGRect toastBounds = oldToastView.bounds;
                toastBounds.size.width = minFrame.size.width;
                oldToastView.bounds = toastBounds;
            } completion:^(BOOL finished) {
                // finally, removing view
                [oldBackgroundView removeFromSuperview];
                RT_RELEASE(oldBackgroundView);
                [oldToastView removeFromSuperview];
                RT_RELEASE(oldToastView);
                [oldMessageView removeFromSuperview];
                RT_RELEASE(oldMessageView);
                _messageView = nil;
            }];
        }];
    }
}

- (BOOL)hasMessage {
    return [_messages count] > 0;
}

- (RTToastMessage *)popNextMessage {
    RTToastMessage *result = nil;
    if ([self hasMessage]) {
        result = [_messages objectAtIndex:0];
        RT_RETAIN(result);
        [_messages removeObjectAtIndex:0];
    }
    return RT_AUTORELEASE(result);
}

- (void)showNextMessage {
    [_hidingTimer invalidate];
    RT_RELEASE(_hidingTimer);
    _hidingTimer = nil;
    if (_messageView) {
        RTToastMessage *message = [self popNextMessage];
        RT_RELEASE(_currentMessage);
        _currentMessage = message;
        RT_RETAIN(_currentMessage);
        __block CGRect messageFrame = _messageView.frame;
        UIView *newMessageView = [self viewForMessage:message withFrame:messageFrame];
        _duration = message.duration;
        [_toastView addSubview:newMessageView];
        UIView *oldMessageView = _messageView;
        _messageView = newMessageView;
        RT_RETAIN(_messageView);
        void(^completionBlock)(BOOL) = ^(BOOL finished) {
            [oldMessageView removeFromSuperview];
            RT_RELEASE(oldMessageView);
            if (finished) {
                _hidingTimer = [NSTimer timerWithTimeInterval:_duration target:self selector:@selector(onHidingTimer:) userInfo:nil repeats:NO];
                [[NSRunLoop currentRunLoop] addTimer:_hidingTimer forMode:NSRunLoopCommonModes];
                RT_RETAIN(_hidingTimer);
            }
        };
        RTToastMessageTransitionType transitionType = message.transitionType;
        if ([RTToastViewAnimator isTransitionSupportedByUIVIew:transitionType]) {
            [UIView transitionFromView:oldMessageView toView:newMessageView duration:RTToastTransisitionAnimationDuration options:(UIViewAnimationOptions)transitionType completion:completionBlock];
        }
        else {
            RTAnimationBlock preAnimationBlock = [RTToastViewAnimator preAnimationBlockForTransitionType:transitionType];
            RTAnimationBlock animationBlock = [RTToastViewAnimator animationBlockForTransitionType:transitionType];
            preAnimationBlock(oldMessageView, newMessageView);
            [UIView animateWithDuration:RTToastTransisitionAnimationDuration delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                animationBlock(oldMessageView, newMessageView);
            } completion:completionBlock];
        }
    }
    else {
        [self showInWindow:_window];
    }
}

- (UIView *)viewForMessage:(RTToastMessage *)message withFrame:(CGRect)frame {
    UIView *result = nil;
    if (message) {
        CGRect messageBounds = frame;
        messageBounds.origin = CGPointMake(0.0f, 0.0f);
        CGRect labelFrame = CGRectInset(messageBounds, RTToastContentInset, RTToastContentInset);
        UIView *messageView = RT_AUTORELEASE([[UIView alloc] initWithFrame:frame]);
        messageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        messageView.backgroundColor = message.backgroundColor;
        if (message.image) {
            UIImageView *imageView = RT_AUTORELEASE([[UIImageView alloc] initWithImage:message.image]);
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            CGRect imageFrame = labelFrame;
            imageFrame.size.width = MIN(imageFrame.size.height, message.image.size.width);
            imageView.frame = imageFrame;
            [messageView addSubview:imageView];
            CGFloat offset = imageFrame.size.width + RTToastContentInset;
            labelFrame.origin.x += offset;
            labelFrame.size.width -= offset;
        }
        UILabel *label = RT_AUTORELEASE([[UILabel alloc] initWithFrame:labelFrame]);
        label.numberOfLines = 4;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = message.textColor;
        label.shadowColor = message.textShadowColor;
        label.shadowOffset = message.textShadowOffset;
        label.font = message.font;
        label.textAlignment = UITextAlignmentCenter;
        label.contentMode = UIViewContentModeCenter;
        label.text = message.text;
        [messageView addSubview:label];
        result = messageView;
    }
    return result;
}

- (void)statusBarOrientationWillChange:(NSNotification *)notification {
    if (_backgroundView) {
        UIInterfaceOrientation newOrientation = [notification.userInfo[UIApplicationStatusBarOrientationUserInfoKey] intValue];
        [self setTransformForOrientation:newOrientation animated:YES];
    }
}

- (void)setTransformForOrientation:(UIInterfaceOrientation)orientation animated:(BOOL)animated {
    // Stay in sync with the superview
    if (_backgroundView.superview) {
        _backgroundView.bounds = _backgroundView.superview.bounds;
        [_backgroundView setNeedsDisplay];
    }
    
    CGFloat radians = 0;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            radians = -(CGFloat)M_PI_2;
        }
        else {
            radians = (CGFloat)M_PI_2;
        }
        // Window coordinates differ!
        _backgroundView.bounds = CGRectMake(0, 0, _backgroundView.bounds.size.height, _backgroundView.bounds.size.width);
    } else {
        if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            radians = (CGFloat)M_PI;
        }
        else {
            radians = 0;
        }
    }
    CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(radians);
    
    //Animating with default duration
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationBeginsFromCurrentState:YES];
    }
    [_backgroundView setTransform:rotationTransform];
    if (animated) {
        [UIView commitAnimations];
    }
}

- (void)singleTapAction:(id)sender {
    if ([self hasMessage]) {
        [self showNextMessage];
    }
    else {
        [self hide];
    }
}

- (void)doubleTapAction:(id)sender {
    [self hide];
}

@end

#undef RT_AUTORELEASE
#undef RT_RELEASE
#undef RT_RETAIN
