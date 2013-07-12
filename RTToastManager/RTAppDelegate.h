//
//  RTAppDelegate.h
//  RTToastManager
//
//  Created by Roman Temchenko on 7/8/13.
//  Copyright (c) 2013 Roman Temchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RTViewController;

@interface RTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) RTViewController *viewController;

@end
