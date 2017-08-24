//
//  FFMainMgr.m
//  FFSplitDemo
//
//  Created by francis zhuo on 2017/8/18.
//  Copyright © 2017年 fenfei. All rights reserved.
//

#import "FFMainMgr.h"
#import "FFMainWindowController.h"

@implementation FFMainMgr
- (id)init{
    self = [super init];
    if (self) {
        _mainWindowController = [[FFMainWindowController alloc] init];
    }
    return self;
}
- (void)haveFun{
    [_mainWindowController.window center];
    [_mainWindowController showWindow:self];
}
@end
