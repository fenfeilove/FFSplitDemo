//
//  FFVideoView.m
//  FFSplitDemo
//
//  Created by francis zhuo on 2017/8/18.
//  Copyright © 2017年 fenfei. All rights reserved.
//

#import "FFVideoView.h"

@implementation FFVideoView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    [[NSColor blackColor] set];
    NSRectFill(self.bounds);
    
    NSAttributedString* attString = [[NSAttributedString alloc] initWithString:@"video view" attributes:@{NSForegroundColorAttributeName:[NSColor whiteColor]}];
    NSRect rcDraw = NSZeroRect;
    rcDraw.size = attString.size;
    rcDraw.origin.x = (NSWidth(self.bounds)-NSWidth(rcDraw))/2;
    rcDraw.origin.y = (NSHeight(self.bounds)-NSHeight(rcDraw))/2;
    [attString drawInRect:rcDraw];
}

@end
