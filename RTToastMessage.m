//
//  RTToastMessage.m
//  RTToastManager
//
//  Created by Roman Temchenko on 7/8/13.
//  Copyright (c) 2013 Roman Temchenko. All rights reserved.
//

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

NSTimeInterval const RTToastMessageDefaultDuration = 4.0;

@interface RTToastMessage ()

- (id)initWithDefaults;
- (id)initWithMessage:(RTToastMessage *)message;

@end

@implementation RTToastMessage

@synthesize text = _text;
@synthesize duration = _duration;
@synthesize image = _image;
@synthesize font = _font;
@synthesize backgroundColor = _backgroundColor;
@synthesize textColor = _textColor;
@synthesize textShadowColor = _textShadowColor;
@synthesize textShadowOffset = _textShadowOffset;

+ (void)initialize {
    if (self == [RTToastMessage class]) {
        appearanceMessage = [[self alloc] initWithDefaults];
    }
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [_text release];
    [_image release];
    [_font release];
    [_backgroundColor release];
    [_textColor release];
    [_textShadowColor release];
    [super dealloc];
#endif
}

- (id)initWithDefaults {
    if (self = [super init]) {
        BOOL isPad = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
        self.duration = RTToastMessageDefaultDuration;
        self.font = [UIFont boldSystemFontOfSize:(isPad ? [UIFont labelFontSize] : [UIFont smallSystemFontSize])];
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        self.textColor = [UIColor whiteColor];
        self.textShadowColor = [UIColor blackColor];
        self.textShadowOffset = CGSizeMake(0.0f, 1.0f);
        self.transitionType = RTToastMessageTransitionMoveInFromRight;
    }
    return self;
}

- (id)init {
    return [self initWithMessage:appearanceMessage];
}

- (id)initWithMessage:(RTToastMessage *)message {
    if (self = [super init]) {
        self.text = message.text;
        self.duration = message.duration;
        self.image = message.image;
        self.font = message.font;
        self.backgroundColor = message.backgroundColor;
        self.textColor = message.textColor;
        self.textShadowColor = message.textShadowColor;
        self.textShadowOffset = message.textShadowOffset;
        self.transitionType = message.transitionType;
    }
    return self;
}

- (id)initWithText:(NSString *)text andDuration:(NSTimeInterval)duration {
    if (self = [self init]) {
        self.text = text;
        self.duration = duration;
    }
    return self;
}

- (id)initWithText:(NSString *)text {
    return [self initWithText:text andDuration:RTToastMessageDefaultDuration];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    RTToastMessage *copy = [[RTToastMessage alloc] init];
    return copy;
}

#pragma mark - UIAppearance

static RTToastMessage *appearanceMessage;

+ (id)appearance {
    return appearanceMessage;
}

+ (id)appearanceWhenContainedIn:(__unsafe_unretained Class<UIAppearanceContainer>)ContainerClass, ... {
    return [self appearance];
}

@end

#undef RT_AUTORELEASE
#undef RT_RELEASE
#undef RT_RETAIN