//
//  COGUAppDelegate.h
//  iOSDevWeekly
//
//  Created by Colin Günther on 08.08.12.
//  Copyright (c) 2012 Cogun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class COGUViewController;

@interface COGUAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) COGUViewController *viewController;

@end
