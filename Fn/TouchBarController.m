//
//  TouchBarController.m
//  DefaultTouchBar
//
//  Created by lonord on 2017/7/29.
//  Copyright © 2017年 lonord. All rights reserved.
//

#import "TouchBarController.h"

@interface TouchBarController ()

@property(nonatomic) NSWindowController* settingController;
@property (strong) IBOutlet NSButton *escBtn;

@end

@implementation TouchBarController

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(100 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
            [self.escBtn scrollPoint:NSMakePoint(70, 0)];
        });
        
    }
    return self;
}

- (IBAction)escClick:(id)sender {
    [self pressKey:0x35];
}

- (IBAction)fnClick:(id)sender {
    NSButton* fnButton = sender;
    NSInteger fnNum = fnButton.tag - 1000;
    
    CGKeyCode key = 0;
    switch (fnNum) {
        case 1:
            key = 0x7A;
            break;
        case 2:
            key = 0x78;
            break;
        case 3:
            key = 0x63;
            break;
        case 4:
            key = 0x76;
            break;
        case 5:
            key = 0x60;
            break;
        case 6:
            key = 0x61;
            break;
        case 7:
            key = 0x62;
            break;
        case 8:
            key = 0x64;
            break;
        case 9:
            key = 0x65;
            break;
        case 10:
            key = 0x6D;
            break;
        case 11:
            key = 0x67;
            break;
        case 12:
            key = 0x6F;
            break;
            
        default:
            return;
    }
    
    [self pressKey:key];
}

- (IBAction)settingClick:(id)sender {
    if (self.settingController == nil) {
        NSStoryboard* settingStoryBoard = [NSStoryboard storyboardWithName:@"Setting" bundle:nil];
        self.settingController = [settingStoryBoard instantiateInitialController];
    }
    [NSApp activateIgnoringOtherApps:YES];
    [self.settingController.window makeKeyAndOrderFront:nil];
}

- (IBAction)exitClick:(id)sender {
    [[NSApplication sharedApplication] terminate:self];
}

- (void)pressKey:(CGKeyCode)key {
    CGEventRef eventDown = CGEventCreateKeyboardEvent(NULL, key, true);
    CGEventRef eventUp = CGEventCreateKeyboardEvent(NULL, key, false);
    CGEventPost(kCGHIDEventTap, eventDown);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        CGEventPost(kCGHIDEventTap, eventUp);
        CFRelease(eventDown);
        CFRelease(eventUp);
    });
}

@end
