//
//  main.m
//  DefaultTouchBar
//
//  Created by lonord on 2017/7/25.
//  Copyright © 2017年 lonord. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

int main(int argc, const char * argv[]) {
    NSApplication* app = [NSApplication sharedApplication];
    id delegate = [[AppDelegate alloc] init];
    [app setDelegate:delegate];
    return NSApplicationMain(argc, argv);
}
