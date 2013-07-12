//
//  RTToastMessage.h
//  RTToastManager
//
//  Created by Roman Temchenko on 7/8/13.
//  Copyright (c) 2013 Roman Temchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSTimeInterval const RTToastMessageDefaultDuration;

typedef enum {
    RTToastMessageTransitionMoveInFromRight = 0,
    RTToastMessageTransitionMoveInFromLeft,
    RTToastMessageTransitionMoveInFromTop,
    RTToastMessageTransitionMoveInFromBottom,
    //UIView supported transitions
    RTToastMessageTransitionFlipFromLeft = UIViewAnimationOptionTransitionFlipFromLeft,
    RTToastMessageTransitionFlipFromRight = UIViewAnimationOptionTransitionFlipFromRight,
    RTToastMessageTransitionFlipFromTop = UIViewAnimationOptionTransitionFlipFromTop,
    RTToastMessageTransitionFlipFromBottom = UIViewAnimationOptionTransitionFlipFromBottom,
    RTToastMessageTransitionCurlUp = UIViewAnimationOptionTransitionCurlUp,
    RTToastMessageTransitionCurlDown = UIViewAnimationOptionTransitionCurlDown,
    RTToastMessageTransitionCrossDissolve = UIViewAnimationOptionTransitionCrossDissolve
} RTToastMessageTransitionType;

@interface RTToastMessage : NSObject <UIAppearance, NSCopying>

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *textShadowColor;
@property (nonatomic, assign) CGSize textShadowOffset;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) RTToastMessageTransitionType transitionType;

- (id)initWithText:(NSString *)text;
- (id)initWithText:(NSString *)text andDuration:(NSTimeInterval)duration;

@end
