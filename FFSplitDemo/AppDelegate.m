//
//  AppDelegate.m
//  FFSplitDemo
//
//  Created by francis zhuo on 2017/8/18.
//  Copyright © 2017年 fenfei. All rights reserved.
//

#import "AppDelegate.h"
#import "FFMainMgr.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    _mainMgr = [[FFMainMgr alloc] init];
    [_mainMgr haveFun];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
