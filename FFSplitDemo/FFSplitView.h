//
//  FFSplitView.h
//  FFSplitView
//
//  Created by francis zhuo on 2017/8/18.
//  Copyright © 2017年 fenfei. All rights reserved.
//

#import <Cocoa/Cocoa.h>
typedef void(^FFSplitViewDrawer)(NSRect bounds);
@interface FFSplitView : NSView{
    BOOL _vertical;
    NSColor* _dividerBackgroundColor;
    NSColor* _dividerPointColor;
    NSImage* _dividerBackgroundImage;
    NSImage* _dividerPointImage;
    FFSplitViewDrawer _dividerDrawer;
    CGFloat  _dividerWidth;
    
    NSTrackingArea* _trackingArea;
    
}
@property (getter=isVertical) BOOL vertical;
@property (retain) NSColor* dividerBackgroundColor;
@property (retain) NSColor* dividerPointColor;
@property (retain) NSImage* dividerBackgroundImage;
@property (retain) NSImage* dividerPointImage;
@property (copy) FFSplitViewDrawer dividerDrawer;
@property (assign) CGFloat dividerWidth;

- (void)setMinimumWidth:(CGFloat)width forViewAtIndex:(NSUInteger)index;
- (void)setMaximumWidth:(CGFloat)width forViewAtIndex:(NSUInteger)index;
- (void)setMinimumHeight:(CGFloat)height forViewAtIndex:(NSUInteger)index;
- (void)setMaximumHeight:(CGFloat)height forViewAtIndex:(NSUInteger)index;

- (void)setMinimumWidth:(CGFloat)width forView:(NSView*)theView;
- (void)setMaximumWidth:(CGFloat)width forView:(NSView*)theView;
- (void)setMinimumHeight:(CGFloat)height forView:(NSView*)theView;
- (void)setMaximumHeight:(CGFloat)height forView:(NSView*)theView;
@end

