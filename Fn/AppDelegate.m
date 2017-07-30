//
//  AppDelegate.m
//  DefaultTouchBar
//
//  Created by lonord on 2017/7/25.
//  Copyright © 2017年 lonord. All rights reserved.
//

#import "AppDelegate.h"
#import "TouchBar.h"
#import "TouchBarController.h"
#import "StorageHelper.h"

static const NSTouchBarItemIdentifier kCtrlBtnIdentifier = @"name.lonord.touchbar.ctrlbtn";

@interface AppDelegate () <NSTouchBarDelegate>

@property(nonatomic) TouchBarController* touchBarViewController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self initTouchBar];
    [self registerNotification];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)registerNotification {
    NSNotificationCenter *nc = [[NSWorkspace sharedWorkspace] notificationCenter];
    [nc addObserver:self selector:@selector(handleAppActivateNoti:) name:NSWorkspaceDidActivateApplicationNotification object:NULL];
}

- (void)initTouchBar {
    DFRSystemModalShowsCloseBoxWhenFrontMost(YES);
    
    NSStoryboard* storyboard = [NSStoryboard storyboardWithName:@"TouchBar" bundle:nil];
    TouchBarController* controller = [storyboard instantiateInitialController];
    self.touchBarViewController = controller;
    
    NSCustomTouchBarItem* ctrlItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:kCtrlBtnIdentifier];
    NSButton* barBtn = [NSButton buttonWithTitle:@"Fn" target:self action:@selector(ctrlClick)];
    [barBtn setFont:[NSFont systemFontOfSize:17.0 weight:2.0]];
    ctrlItem.view = barBtn;
    [NSTouchBarItem addSystemTrayItem:ctrlItem];
    
    DFRElementSetControlStripPresenceForIdentifier(kCtrlBtnIdentifier, YES);
}

- (void)handleAppActivateNoti:(NSNotification *)noti {
    NSRunningApplication *runningApp = (NSRunningApplication *)[noti.userInfo objectForKey:@"NSWorkspaceApplicationKey"];
    NSString *identifier = runningApp.bundleIdentifier;
    
    StorageHelper* storage = [StorageHelper sharedStorage];
    if (!storage.autoSwitchApp) {
        return;
    }
    NSArray* appArray = storage.switchAppArray;
    if ([self isAppInArray:appArray appIdentifier:identifier]) {
        [self hideTouchBar];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(100 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
            [self ctrlClick];
        });
    } else if (storage.hideInOtherApp) {
        [self hideTouchBar];
    }
}

- (void)ctrlClick {
    [NSTouchBar presentSystemModalFunctionBar:self.touchBarViewController.touchBar
                     systemTrayItemIdentifier:kCtrlBtnIdentifier];
}

- (void)hideTouchBar {
    [NSTouchBar minimizeSystemModalFunctionBar:self.touchBarViewController.touchBar];
}

- (BOOL)isAppInArray:(NSArray*)appArray appIdentifier:(NSString*)identifier {
    for (NSArray* item in appArray) {
        if ([identifier isEqualToString:item[0]]) {
            return YES;
        }
    }
    return NO;
}

@end
