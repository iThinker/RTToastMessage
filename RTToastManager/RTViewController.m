//
//  RTViewController.m
//  RTToastManager
//
//  Created by Roman Temchenko on 7/8/13.
//  Copyright (c) 2013 Roman Temchenko. All rights reserved.
//

#import "RTViewController.h"
#import "RTToastManager.h"
#import "RTToastMessage.h"

@interface RTViewController ()

@end

@implementation RTViewController

- (void)showBrown:(id)sender {
    RTToastMessage *message = [[RTToastMessage alloc] initWithText:@"Brown"];
    message.backgroundColor = [UIColor brownColor];
    [[RTToastManager sharedManager] showMessage:message];
}

- (void)showFox:(id)sender {
    RTToastMessage *message = [[RTToastMessage alloc] initWithText:@"Fox"];
    message.image = [UIImage imageNamed:@"fox.png"];
    message.textColor = [UIColor orangeColor];
    message.textShadowColor = [UIColor redColor];
    message.textShadowOffset = CGSizeMake(2.0f, 2.0f);
    [[RTToastManager sharedManager] showMessage:message];
}

- (void)showJumps:(id)sender {
    RTToastMessage *message = [[RTToastMessage alloc] initWithText:@"Jumps"];
    message.backgroundColor = [UIColor blueColor];
    message.transitionType = RTToastMessageTransitionCurlDown;
    [[RTToastManager sharedManager] showMessage:message];
}

- (void)showOver:(id)sender {
    RTToastMessage *message = [[RTToastMessage alloc] initWithText:@"Over"];
    message.transitionType = RTToastMessageTransitionFlipFromTop;
    [[RTToastManager sharedManager] showMessage:message];
}

- (void)showThe:(id)sender {
    RTToastMessage *message = [[RTToastMessage alloc] initWithText:@"The"];
    message.backgroundColor= [UIColor redColor];
    message.transitionType = RTToastMessageTransitionCrossDissolve;
    [[RTToastManager sharedManager] showMessage:message];
}

- (void)showLazy:(id)sender {
    [[RTToastManager sharedManager] showMessageWithText:@"Lazy"];
}

- (void)showDog:(id)sender {
    RTToastMessage *message = [[RTToastMessage alloc] initWithText:@"Dog"];
    message.image = [UIImage imageNamed:@"dog.png"];
    message.backgroundColor = [UIColor whiteColor];
    message.textColor = [UIColor darkTextColor];
    message.textShadowColor = nil;
    message.transitionType = RTToastMessageTransitionFlipFromLeft;
    [[RTToastManager sharedManager] showMessage:message];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

@end
