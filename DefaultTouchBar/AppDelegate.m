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

static const NSTouchBarItemIdentifier kCtrlBtnIdentifier = @"name.lonord.touchbar.ctrlbtn";
static const NSTouchBarItemIdentifier kF1Identifier = @"name.lonord.touchbar.f1";
static const NSTouchBarItemIdentifier kF2Identifier = @"name.lonord.touchbar.f2";
static const NSTouchBarItemIdentifier kF3Identifier = @"name.lonord.touchbar.f3";
static const NSTouchBarItemIdentifier kF4Identifier = @"name.lonord.touchbar.f4";
static const NSTouchBarItemIdentifier kF5Identifier = @"name.lonord.touchbar.f5";
static const NSTouchBarItemIdentifier kF6Identifier = @"name.lonord.touchbar.f6";
static const NSTouchBarItemIdentifier kF7Identifier = @"name.lonord.touchbar.f7";
static const NSTouchBarItemIdentifier kF8Identifier = @"name.lonord.touchbar.f8";
static const NSTouchBarItemIdentifier kF9Identifier = @"name.lonord.touchbar.f9";
static const NSTouchBarItemIdentifier kF10Identifier = @"name.lonord.touchbar.f10";
static const NSTouchBarItemIdentifier kF11Identifier = @"name.lonord.touchbar.f11";
static const NSTouchBarItemIdentifier kF12Identifier = @"name.lonord.touchbar.f12";

@interface AppDelegate () <NSTouchBarDelegate>

@property(nonatomic, strong) NSStatusItem* appStatusItem;
@property(nonatomic) NSTouchBar* touchBar;
@property(nonatomic) NSCustomTouchBarItem* ctrlItem;
@property(nonatomic) NSTouchBarItem* f1Item;
@property(nonatomic) NSTouchBarItem* f2Item;
@property(nonatomic) NSTouchBarItem* f3Item;
@property(nonatomic) NSTouchBarItem* f4Item;
@property(nonatomic) NSTouchBarItem* f5Item;
@property(nonatomic) NSTouchBarItem* f6Item;
@property(nonatomic) NSTouchBarItem* f7Item;
@property(nonatomic) NSTouchBarItem* f8Item;
@property(nonatomic) NSTouchBarItem* f9Item;
@property(nonatomic) NSTouchBarItem* f10Item;
@property(nonatomic) NSTouchBarItem* f11Item;
@property(nonatomic) NSTouchBarItem* f12Item;

@property(nonatomic) TouchBarController* touchBarViewController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
//    [self initStatusItem];
//    [self registerNotification];
    [self initTouchBar];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)initStatusItem {
    self.appStatusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.appStatusItem.title = @"Fn";
}

- (void)registerNotification {
    NSNotificationCenter *nc = [[NSWorkspace sharedWorkspace] notificationCenter];
    [nc addObserver:self selector:@selector(handleAppActivateNoti:) name:NSWorkspaceDidActivateApplicationNotification object:NULL];
    [nc addObserver:self selector:@selector(handleAppDeactiveNoti:) name:NSWorkspaceDidDeactivateApplicationNotification object:NULL];
}

- (void)initTouchBar {
    DFRSystemModalShowsCloseBoxWhenFrontMost(YES);
    
    NSStoryboard* storyboard = [NSStoryboard storyboardWithName:@"TouchBar" bundle:nil];
    TouchBarController* controller = [storyboard instantiateInitialController];
    self.touchBarViewController = controller;
    
    _touchBar = controller.touchBar;
    
//    _touchBar = [[NSTouchBar alloc] init];
//    _touchBar.delegate = self;
//    _touchBar.defaultItemIdentifiers = @[kF1Identifier, kF2Identifier, kF3Identifier, kF4Identifier, kF5Identifier, kF6Identifier, kF7Identifier, kF8Identifier, kF9Identifier, kF10Identifier, kF11Identifier, kF12Identifier];
    
    _ctrlItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:kCtrlBtnIdentifier];
    NSButton* barBtn = [NSButton buttonWithTitle:@"Fn" target:self action:@selector(ctrlClick)];
    [barBtn setFont:[NSFont systemFontOfSize:17.0 weight:2.0]];
    _ctrlItem.view = barBtn;
    [NSTouchBarItem addSystemTrayItem:_ctrlItem];
    
    DFRElementSetControlStripPresenceForIdentifier(kCtrlBtnIdentifier, YES);
}

- (void)handleAppDeactiveNoti:(NSNotification *)noti {
    //
}

- (void)handleAppActivateNoti:(NSNotification *)noti {
//    NSRunningApplication *runningApp = (NSRunningApplication *)[noti.userInfo objectForKey:@"NSWorkspaceApplicationKey"];
//    NSString *identifier = runningApp.bundleIdentifier;
}

- (NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar
       makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier
{
    NSCustomTouchBarItem* customItem = [[NSCustomTouchBarItem alloc] initWithIdentifier:identifier];
    if ([identifier isEqualToString:kF1Identifier]) {
        customItem.view = [self makeFnButtonWithTitle:@"F1" target:self action:@selector(f1Click)];
    } else if ([identifier isEqualToString:kF2Identifier]) {
        customItem.view = [self makeFnButtonWithTitle:@"F2" target:self action:@selector(f2Click)];
    } else if ([identifier isEqualToString:kF3Identifier]) {
        customItem.view = [self makeFnButtonWithTitle:@"F3" target:self action:@selector(f3Click)];
    } else if ([identifier isEqualToString:kF4Identifier]) {
        customItem.view = [self makeFnButtonWithTitle:@"F4" target:self action:@selector(f4Click)];
    } else if ([identifier isEqualToString:kF5Identifier]) {
        customItem.view = [self makeFnButtonWithTitle:@"F5" target:self action:@selector(f5Click)];
    } else if ([identifier isEqualToString:kF6Identifier]) {
        customItem.view = [self makeFnButtonWithTitle:@"F6" target:self action:@selector(f6Click)];
    } else if ([identifier isEqualToString:kF7Identifier]) {
        customItem.view = [self makeFnButtonWithTitle:@"F7" target:self action:@selector(f7Click)];
    } else if ([identifier isEqualToString:kF8Identifier]) {
        customItem.view = [self makeFnButtonWithTitle:@"F8" target:self action:@selector(f8Click)];
    } else if ([identifier isEqualToString:kF9Identifier]) {
        customItem.view = [self makeFnButtonWithTitle:@"F9" target:self action:@selector(f9Click)];
    } else if ([identifier isEqualToString:kF10Identifier]) {
        customItem.view = [self makeFnButtonWithTitle:@"F10" target:self action:@selector(f10Click)];
    } else if ([identifier isEqualToString:kF11Identifier]) {
        customItem.view = [self makeFnButtonWithTitle:@"F11" target:self action:@selector(f11Click)];
    } else if ([identifier isEqualToString:kF12Identifier]) {
        customItem.view = [self makeFnButtonWithTitle:@"F12" target:self action:@selector(f12Click)];
    }
    return customItem;
}

- (NSButton*)makeFnButtonWithTitle:(NSString*)title target:(id)target action:(SEL)action {
    NSButton* btn = [NSButton buttonWithTitle:title target:target action:action];
//    btn.frame = NSMakeRect(0, 0, 60, 30);
    [btn addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60.0]];
    return btn;
}

/*********************************************** actions ***********************************************/

- (void)ctrlClick {
    [NSTouchBar presentSystemModalFunctionBar:self.touchBar
                     systemTrayItemIdentifier:kCtrlBtnIdentifier];
}

- (void)f1Click {
    NSLog(@"f1 click");
}

- (void)f2Click {
    //
}

- (void)f3Click {
    //
}

- (void)f4Click {
    //
}

- (void)f5Click {
    //
}

- (void)f6Click {
    //
}

- (void)f7Click {
    //
}

- (void)f8Click {
    //
}

- (void)f9Click {
    //
}

- (void)f10Click {
    //
}

- (void)f11Click {
    //
}

- (void)f12Click {
    //
}

@end
