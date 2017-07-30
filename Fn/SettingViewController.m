//
//  SettingViewController.m
//  Fn
//
//  Created by lonord on 2017/7/29.
//  Copyright © 2017年 lonord. All rights reserved.
//

#import "SettingViewController.h"
#import "StorageHelper.h"

@interface SettingViewController () <NSTableViewDataSource,NSTableViewDelegate>

@property (strong) IBOutlet NSTextField *nameLabel;
@property (strong) IBOutlet NSTextField *verLabel;
@property (strong) IBOutlet NSButton *autoShowSwitch;
@property (strong) IBOutlet NSButton *otherHideSwitch;
@property (strong) IBOutlet NSButton *addApp;
@property (strong) IBOutlet NSButton *removeApp;
@property (strong) IBOutlet NSTableView *appTable;
@property (strong) IBOutlet NSScrollView *scrollView;

@property(nonatomic) NSMutableArray* appArray;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showVersionInfo];
    [self readConfig];
}

- (void)showVersionInfo {
    NSDictionary* infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString* appName = [infoDic objectForKey:@"CFBundleName"];
    NSString* shortVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [infoDic objectForKey:@"CFBundleVersion"];
    
    [self.nameLabel setStringValue:appName];
    [self.verLabel setStringValue:[NSString stringWithFormat:@"%@(%@)", shortVersion, build]];
}

- (void)readConfig {
    StorageHelper* storage = [StorageHelper sharedStorage];
    [self applyAutoShowSwitchValue:storage.autoSwitchApp];
    [self applyAppIdentifierArray:storage.switchAppArray];
    [self applyHideSwitchValue:storage.hideInOtherApp];
    
    [self handleAutoShowSwitchChanged:storage.autoSwitchApp];
}

- (void)writeConfig {
    StorageHelper* storage = [StorageHelper sharedStorage];
    storage.autoSwitchApp = self.autoShowSwitch.state == NSOnState;
    storage.hideInOtherApp = self.otherHideSwitch.state == NSOnState;
    storage.switchAppArray = self.appArray;
    
    [storage flush];
}

- (void)applyAutoShowSwitchValue:(BOOL)isOn {
    [self.autoShowSwitch setState:isOn ? NSOnState : NSOffState];
}

- (void)applyHideSwitchValue:(BOOL)isOn {
    [self.otherHideSwitch setState:isOn ? NSOnState : NSOffState];
}

- (void)applyAppIdentifierArray:(NSArray*)appArray {
    self.appArray = [NSMutableArray arrayWithArray:appArray];
}

- (void)handleAutoShowSwitchChanged:(BOOL)isOn {
    if (isOn) {
        [self.appTable setEnabled:YES];
        [self.otherHideSwitch setEnabled:YES];
        [self.addApp setEnabled:YES];
        if (self.appTable.selectedRow > -1) {
            [self.removeApp setEnabled:YES];
        }
    } else {
        [self.appTable setEnabled:NO];
        [self.otherHideSwitch setEnabled:NO];
        [self.addApp setEnabled:NO];
        [self.removeApp setEnabled:NO];
    }
}

- (BOOL)isAppDuplicated:(NSString*)identifier {
    for (NSArray* item in self.appArray) {
        if ([identifier isEqualToString:item[0]]) {
            return YES;
        }
    }
    return NO;
}

- (IBAction)autoShowSwitchChanged:(id)sender {
    [self applyAutoShowSwitchValue:self.autoShowSwitch.state == NSOnState];
    
    [self handleAutoShowSwitchChanged:self.autoShowSwitch.state == NSOnState];
    
    [self writeConfig];
}

- (IBAction)otherHideSwitchChanged:(id)sender {
    [self writeConfig];
}

- (IBAction)addAppClick:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    NSArray *appDirs = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSLocalDomainMask, YES);
    NSString *appDir = [appDirs objectAtIndex:0];
    [panel setDirectoryURL:[NSURL URLWithString:appDir]];
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:NO];
    [panel setAllowsMultipleSelection:NO];
    
    NSInteger clicked = [panel runModal];
    
    if (clicked == NSFileHandlingPanelOKButton) {
        for (NSURL *url in [panel URLs]) {
            
            NSBundle *selectedAppBundle =[NSBundle bundleWithURL:url];
            NSString *bundleIdentifier = [selectedAppBundle bundleIdentifier];
            if([self isAppDuplicated:bundleIdentifier]) {
                break;
            }
            NSString *appName = [[NSFileManager defaultManager] displayNameAtPath: [selectedAppBundle bundlePath]];
            NSArray* appItem = @[bundleIdentifier, appName, [url path]];
            
            [self.appArray addObject:appItem];
            [self.appTable reloadData];
            
            [self writeConfig];
            
            break;
        }
    }
}

- (IBAction)removeAppClick:(id)sender {
    [self.appArray removeObjectAtIndex:self.appTable.selectedRow];
    [self.appTable reloadData];
    [self.removeApp setEnabled:NO];
    
    [self writeConfig];
}

- (IBAction)exitClick:(id)sender {
    [[NSApplication sharedApplication] terminate:self];
}


- (NSInteger)numberOfRowsInTableView:(NSTableView*)tableView{
    return self.appArray.count;
}

- (NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTableCellView* appCell = [tableView makeViewWithIdentifier:@"appCell" owner:nil];
    NSArray* appItem = self.appArray[row];
    appCell.imageView.image = [[NSWorkspace sharedWorkspace] iconForFile:appItem[2]];
    appCell.textField.stringValue = appItem[1];
    return appCell;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 20.0;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    [self.removeApp setEnabled:self.appTable.selectedRow > -1];
}

@end
