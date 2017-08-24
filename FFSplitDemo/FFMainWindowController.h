//
//  FFMainWindowController.h
//  FFSplitDemo
//
//  Created by francis zhuo on 2017/8/18.
//  Copyright © 2017年 fenfei. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FFSplitView;
@interface FFMainWindowController : NSWindowController
{
    FFSplitView*        _splitView;
    NSSegmentedControl* _layoutButtons;
}
@end
