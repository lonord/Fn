//
//  StorageHelper.m
//  Fn
//
//  Created by lonord on 2017/7/30.
//  Copyright © 2017年 lonord. All rights reserved.
//

#import "StorageHelper.h"

@interface StorageHelper ()

@property(nonatomic) NSUserDefaults* userDefaults;

@end

@implementation StorageHelper

StorageHelper* instance;

+ (StorageHelper*)sharedStorage {
    if (instance == nil) {
        instance = [[StorageHelper alloc] init];
        instance.userDefaults = [NSUserDefaults standardUserDefaults];
        [instance reloadConfig];
    }
    return instance;
}

- (void)reloadConfig {
    self.autoSwitchApp = [[self.userDefaults objectForKey:@"autoSwitchApp"] boolValue];
    self.switchAppArray = [self.userDefaults objectForKey:@"switchAppArray"];
    self.hideInOtherApp = [[self.userDefaults objectForKey:@"hideInOtherApp"] boolValue];
}

- (void)flush {
    [self.userDefaults setObject:[NSNumber numberWithBool:self.autoSwitchApp] forKey:@"autoSwitchApp"];
    [self.userDefaults setObject:self.switchAppArray forKey:@"switchAppArray"];
    [self.userDefaults setObject:[NSNumber numberWithBool:self.hideInOtherApp] forKey:@"hideInOtherApp"];
}

@end
