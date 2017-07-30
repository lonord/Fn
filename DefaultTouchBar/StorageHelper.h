//
//  StorageHelper.h
//  Fn
//
//  Created by lonord on 2017/7/30.
//  Copyright © 2017年 lonord. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StorageHelper : NSObject

@property(nonatomic) BOOL autoSwitchApp;
@property(nonatomic) NSArray* switchAppArray;
@property(nonatomic) BOOL hideInOtherApp;

+ (StorageHelper*)sharedStorage;
- (void)reloadConfig;
- (void)flush;

@end
