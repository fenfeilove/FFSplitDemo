//
//  FFSplitView.m
//  FFSplitView
//
//  Created by francis zhuo on 2017/8/18.
//  Copyright © 2017年 fenfei. All rights reserved.
//

#import "FFSplitView.h"

@interface FFSplitView (){
    NSMutableArray* _internalConstraints;
}
@property (retain) NSMutableArray* internalConstraints;
@property (retain) NSMutableArray* sizingConstraints;
@property (retain) NSLayoutConstraint* draggingConstraint;
@property (retain) NSLayoutConstraint* preViewConstraint;
@property (retain) NSLayoutConstraint* nextViewConstraint;
@end

@implementation FFSplitView
@synthesize vertical = _vertical;
@synthesize dividerBackgroundColor = _dividerBackgroundColor;
@synthesize dividerPointColor = _dividerPointColor;
@synthesize dividerBackgroundImage = _dividerBackgroundImage;
@synthesize dividerPointImage = _dividerPointImage;
@synthesize dividerDrawer = _dividerDrawer;
@synthesize dividerWidth = _dividerWidth;
@synthesize internalConstraints = _internalConstraints;
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        
    }
    return self;
}

- (void)cleanUp{
    [self destroyTrackingArea];
    if(_dividerBackgroundColor){
        [_dividerBackgroundColor release];
        _dividerBackgroundColor = nil;
    }
    if(_dividerPointColor){
        [_dividerPointColor release];
        _dividerPointColor = nil;
    }
    if(_dividerBackgroundImage){
        [_dividerBackgroundImage release];
        _dividerBackgroundImage = nil;
    }
    if(_dividerPointImage){
        [_dividerPointImage release];
        _dividerPointImage = nil;
    }
    if(_dividerDrawer){
        [_dividerDrawer release];
        _dividerDrawer = nil;
    }
}
- (void)dealloc{
    NSLog(@"%s %p",__func__,self);
    [self cleanUp];
    [super dealloc];
}

#pragma mark trackingArea
- (void)viewDidMoveToWindow{
    [self updateTrackingAreas];
}

- (void)updateTrackingAreas{
    if(self.window)
        [self createTrackingArea];
    else
        [self destroyTrackingArea];
    [super updateTrackingAreas];
}
- (void)createTrackingArea
{
    if(_trackingArea == nil){
        _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds
                                                          options:NSTrackingInVisibleRect | NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved
                                                            owner:self
                                                         userInfo:nil];
        if(![self.trackingAreas containsObject:_trackingArea])
            [self addTrackingArea:_trackingArea];
    }
}

- (void)destroyTrackingArea
{
    if(_trackingArea){
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release];
        _trackingArea = nil;
    }
}
#pragma mark subview add&romove
- (void)updateConstraints
{
    if (!self.internalConstraints)
    {
        [self updateInternalConstraints];
    }
    [super updateConstraints];
}
- (void)updateInternalConstraints
{
    NSArray* subViews = [self subviews];
    NSUInteger viewCnt = [subViews count];
    NSMutableArray* constraints = [NSMutableArray arrayWithCapacity:viewCnt];
    NSDictionary* metrics = @{@"dividerWidth":@(_dividerWidth)};
    NSView* previousView = nil;
    NSView* currentView = nil;
    NSString* format = nil;
    for(NSUInteger i = 0; i < viewCnt; i++){
        currentView = [subViews objectAtIndex:i];
        if(!previousView){
            if(_vertical){
                format = @"H:|[currentView]";
            }
            else{
                format = @"V:|[currentView]";
            }
            [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:@{@"currentView":currentView}]];
        }
        else{
            if(_vertical){
                format = @"H:[previousView]-dividerWidth-[currentView]";
            }
            else{
                format = @"V:[previousView]-dividerWidth-[currentView]";
            }
            [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:@{@"previousView":previousView,@"currentView":currentView}]];
        }
        
        if(_vertical){
            format = @"V:|[currentView]|";
        }
        else{
            format = @"H:|[currentView]|";
        }
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:@{@"currentView":currentView}]];
        
        previousView = currentView;
    }
    
    if (currentView){
        if (_vertical){
            format = @"H:[currentView]|";
        }
        else{
            format = @"V:[currentView]|";
        }
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:@{@"currentView":currentView}]];
    }
    
    [self addInternalConstraints:constraints];
}

- (void)updateSizingContstraintsForDividerIndex:(NSInteger)dividerIndex
{
    
    NSArray* subViews = [self subviews];
    NSUInteger viewCnt = [subViews count];
    if(!viewCnt)
        return;
    
    NSMutableArray* constraints = [NSMutableArray array];
    CGFloat spaceForAllDivider = _dividerWidth*[self numberOfDivider];
    CGFloat spaceForAllSubViews = 0.f;
    if(_vertical){
        spaceForAllSubViews = NSWidth(self.bounds) - spaceForAllDivider;
    }
    else{
        spaceForAllSubViews = NSHeight(self.bounds) - spaceForAllDivider;
    }
    
    for (NSUInteger i = 0; i < viewCnt; i++)
    {
        NSView *currentView = [subViews objectAtIndex:i];
        NSLayoutConstraint* constraint = nil;
        if (_vertical){
            constraint = [NSLayoutConstraint constraintWithItem:currentView
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:nil
                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                     multiplier:1.0
                                                       constant:NSWidth(currentView.frame)];
        }
        else{
            constraint = [NSLayoutConstraint constraintWithItem:currentView
                                                      attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:nil
                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                     multiplier:1.0
                                                       constant:NSHeight(currentView.frame)];
        }
        constraint.priority = NSLayoutPriorityDefaultLow;
        [constraints addObject:constraint];
    }
    [self addSizingConstrants:constraints];
}
- (void)didAddSubview:(NSView *)subview{
    [subview setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addInternalConstraints:nil];
    [super didAddSubview:subview];
}

- (void)willRemoveSubview:(NSView *)subview
{
    NSMutableArray *constraintsToRemove = [NSMutableArray array];
    for(NSLayoutConstraint *c in [self constraints]){
        if(([c secondItem] == subview) || ([c firstItem] == subview)){
            [constraintsToRemove addObject:c];
        }
    }
    [self removeConstraints:constraintsToRemove];
    [self addInternalConstraints:nil];
    [super willRemoveSubview:subview];
}
#pragma mark width&height
- (void)setMinimumWidth:(CGFloat)width forViewAtIndex:(NSUInteger)index{
    if(index>=self.subviews.count)
        return;
    NSView* theView = [self.subviews objectAtIndex:index];
    return [self setMinimumWidth:width forView:theView];
}
- (void)setMaximumWidth:(CGFloat)width forViewAtIndex:(NSUInteger)index{
    if(index>=self.subviews.count)
        return;
    NSView* theView = [self.subviews objectAtIndex:index];
    return [self setMaximumWidth:width forView:theView];
}
- (void)setMinimumHeight:(CGFloat)height forViewAtIndex:(NSUInteger)index{
    if(index>=self.subviews.count)
        return;
    NSView* theView = [self.subviews objectAtIndex:index];
    return [self setMinimumHeight:height forView:theView];
}
- (void)setMaximumHeight:(CGFloat)height forViewAtIndex:(NSUInteger)index{
    if(index>=self.subviews.count)
        return;
    NSView* theView = [self.subviews objectAtIndex:index];
    return [self setMaximumHeight:height forView:theView];
}

- (void)setMinimumWidth:(CGFloat)width forView:(NSView*)theView{
    if(!theView)
        return;
    if(![self.subviews containsObject:theView])
        return;
    NSDictionary* metrics = @{@"minWidth":@(width)};
    NSString* format = @"H:[theView(>=minWidth)]";
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:NSDictionaryOfVariableBindings(theView)];
    [self addConstraints:constraints];
    [self setNeedsUpdateConstraints:YES];
}
- (void)setMaximumWidth:(CGFloat)width forView:(NSView*)theView{
    if(!theView)
        return;
    if(![self.subviews containsObject:theView])
        return;
    NSDictionary* metrics = @{@"maxWidth":@(width)};
    NSString* format = @"H:[theView(<=maxWidth)]";
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format
                                                                   options:0
                                                                   metrics:metrics
                                                                     views:NSDictionaryOfVariableBindings(theView)];
    [self addConstraints:constraints];
    [self setNeedsUpdateConstraints:YES];
}
- (void)setMinimumHeight:(CGFloat)height forView:(NSView*)theView{
    if(!theView)
        return;
    if(![self.subviews containsObject:theView])
        return;
    NSDictionary* metrics = @{@"minHeight":@(height)};
    NSString* format = @"V:[theView(>=minHeight)]";
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format
                                                                   options:0
                                                                   metrics:metrics
                                                                     views:NSDictionaryOfVariableBindings(theView)];
    [self addConstraints:constraints];
    [self setNeedsUpdateConstraints:YES];
}
- (void)setMaximumHeight:(CGFloat)height forView:(NSView*)theView{
    if(!theView)
        return;
    if(![self.subviews containsObject:theView])
        return;
    NSDictionary* metrics = @{@"maxHeight":@(height)};
    NSString* format = @"V:[theView(<=maxHeight)]";
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format
                                                                   options:0
                                                                   metrics:metrics
                                                                     views:NSDictionaryOfVariableBindings(theView)];
    [self addConstraints:constraints];
    [self setNeedsUpdateConstraints:YES];
}

- (CGFloat)minimumWidthForViewAtIndex:(NSInteger)index
{
    return 0.f;
}

- (void)addInternalConstraints:(NSMutableArray *)constraints
{
    if (constraints == self.internalConstraints){
        return;
    }
    if (self.internalConstraints){
        [self removeConstraints:self.internalConstraints];
    }
    self.internalConstraints = constraints;
    if (self.internalConstraints){
        [self addConstraints:self.internalConstraints];
    }
    else{
        [self setNeedsUpdateConstraints:YES];
    }
}
- (void)addSizingConstrants:(NSMutableArray *)constraints
{
    if (self.sizingConstraints == constraints)
    {
        return;
    }
    if (self.sizingConstraints)
    {
        [self removeConstraints:self.sizingConstraints];
    }
    self.sizingConstraints = constraints;
    if (self.sizingConstraints)
    {
        [self addConstraints:self.sizingConstraints];
    }
    else
    {
        [self setNeedsUpdateConstraints:YES];
    }
}

#pragma mark divider property
- (NSUInteger)numberOfDivider{
    return [[self subviews] count] - 1;
}

- (NSRect)rectOfDividerAtIndex:(NSUInteger)index{
    if (index >= [self numberOfDivider]){
        return NSZeroRect;
    }
    
    NSRect rcDivider = NSZeroRect;
    NSView* theView = [self.subviews objectAtIndex:index];
    
    if(_vertical){
        rcDivider.origin.x = NSMaxX(theView.frame);
        rcDivider.origin.y = 0.f;
        rcDivider.size.height = NSHeight(self.bounds);
        rcDivider.size.width = self.dividerWidth;
    }
    else{
        rcDivider.origin.x = 0.f;
        rcDivider.origin.y = NSMaxY(theView.frame);
        rcDivider.size.height = self.dividerWidth;
        rcDivider.size.width = NSWidth(self.bounds);
    }
    return rcDivider;
}

- (NSInteger)dividerIndexForPoint:(NSPoint)thePoint{
    NSUInteger dividerCnt = [self numberOfDivider];
    for(NSInteger i = 0; i < dividerCnt; ++i){
        NSRect rcDivider = [self rectOfDividerAtIndex:i];
        if(NSMouseInRect(thePoint, rcDivider, self.isFlipped)){
            return i;
        }
    }
    return NSNotFound;
}
#pragma mark draw
- (void)drawRect:(NSRect)dirtyRect{
    [[NSColor colorWithSRGBRed:228/255.0 green:228/255.0 blue:237/255.0 alpha:1] set];
    NSRectFill(dirtyRect);
    NSUInteger dividerCnt = [self numberOfDivider];
    for(NSUInteger i = 0; i < dividerCnt; ++i){
        NSRect rcDivider = [self rectOfDividerAtIndex:i];
        if(_dividerDrawer){
            _dividerDrawer(rcDivider);
        }
        else{
            //draw background
            if(_dividerBackgroundImage){
                [_dividerBackgroundImage drawInRect:rcDivider fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.f respectFlipped:YES hints:@{NSImageHintInterpolation:@(NSImageInterpolationNone)}];
            }
            else if(_dividerBackgroundColor){
                [_dividerBackgroundColor set];
                NSRectFill(rcDivider);
            }
            
            //draw point
            if(_dividerPointImage){
                NSRect theRect = NSZeroRect;
                theRect.size = _dividerPointImage.size;
                theRect.origin.x = NSMinX(rcDivider) + ceil((NSWidth(rcDivider) - NSWidth(theRect))/2.0);
                theRect.origin.y = NSMinY(rcDivider) + ceilf((NSHeight(rcDivider) - NSHeight(theRect))/2.0);
                [_dividerPointImage drawInRect:theRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.f respectFlipped:YES hints:@{NSImageHintInterpolation:@(NSImageInterpolationNone)}];
            }
            else if(_dividerPointColor){
                CGFloat radius = floor(self.dividerWidth/2);
                NSRect theRect = NSZeroRect;
                theRect.size = NSMakeSize(radius, radius);
                theRect.origin.x = NSMinX(rcDivider) + ceil((NSWidth(rcDivider) - NSWidth(theRect))/2.0);
                theRect.origin.y = NSMinY(rcDivider) + ceilf((NSHeight(rcDivider) - NSHeight(theRect))/2.0);
                NSBezierPath* path = [NSBezierPath bezierPathWithRoundedRect:theRect xRadius:radius/2 yRadius:radius/2];
                [_dividerPointColor set];
                [path fill];
            }
        }
    }
}

#pragma mark - mouse overrides
- (void)mouseDown:(NSEvent *)theEvent{
    NSLog(@"%s",__func__);
    NSPoint location = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSInteger dividerIndex = [self dividerIndexForPoint:location];

    if(dividerIndex == NSNotFound){
        [super mouseDown:theEvent];
    }
    else{
        NSView* theView = [self.subviews objectAtIndex:dividerIndex];
        NSView* nextView = [self.subviews objectAtIndex:dividerIndex+1];
        if (_vertical){
            _draggingConstraint = [[[NSLayoutConstraint constraintsWithVisualFormat:@"H:[theView]-10-|" options:0 metrics:nil views:@{@"theView":theView}] lastObject] retain];
            _draggingConstraint.constant = NSWidth(self.bounds) - location.x + _dividerWidth/2.f;
            
            _preViewConstraint = [[NSLayoutConstraint constraintWithItem:theView attribute:NSLayoutAttributeLeading
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeLeading
                                                              multiplier:1.0
                                                                constant:NSMinX(theView.frame)] retain];
            _nextViewConstraint = [[NSLayoutConstraint constraintWithItem:nextView attribute:NSLayoutAttributeTrailing
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeLeading
                                                               multiplier:1.0
                                                                 constant:NSMaxX(nextView.frame)] retain];
        }
        else{
            _draggingConstraint = [[[NSLayoutConstraint constraintsWithVisualFormat:@"V:[theView]-10-|" options:0 metrics:nil views:@{@"theView":theView}] lastObject] retain];
            _draggingConstraint.constant = NSHeight(self.bounds) - location.y + _dividerWidth/2.f;
            
            _preViewConstraint = [[NSLayoutConstraint constraintWithItem:theView attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1.0
                                                                constant:NSMinY(theView.frame)] retain];
            _nextViewConstraint = [[NSLayoutConstraint constraintWithItem:nextView attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0
                                                                 constant:NSMaxY(nextView.frame)] retain];
        }
        [_draggingConstraint setPriority:NSLayoutPriorityDragThatCannotResizeWindow];
        [_preViewConstraint setPriority:NSLayoutPriorityDragThatCannotResizeWindow-1];
        [_nextViewConstraint setPriority:NSLayoutPriorityDragThatCannotResizeWindow-1];
        [self addConstraint:_draggingConstraint];
        [self addConstraint:_preViewConstraint];
        [self addConstraint:_nextViewConstraint];
        [self setNeedsDisplay:YES];
    }
}

- (void)mouseDragged:(NSEvent *)theEvent{
//    NSLog(@"%s",__func__);
    if (self.draggingConstraint){
        NSPoint location = [self convertPoint:[theEvent locationInWindow] fromView:nil];
        if(_vertical){
            _draggingConstraint.constant = NSWidth(self.bounds) - location.x + _dividerWidth/2.f;
        }
        else{
            _draggingConstraint.constant = NSHeight(self.bounds) - location.y + _dividerWidth/2.f;
        }
        [self setNeedsDisplay:YES];
    }
    else{
        [super mouseDragged:theEvent];
    }
}

- (void)mouseUp:(NSEvent *)theEvent{
//    NSLog(@"%s",__func__);
    if(_draggingConstraint){
        [self removeConstraint:self.draggingConstraint];
        [_draggingConstraint release];
        _draggingConstraint = nil;
        [self updateSizingContstraintsForDividerIndex:0];
        [self setNeedsDisplay:YES];
    }
    else{
        [super mouseUp:theEvent];
    }
}

- (void)mouseEntered:(NSEvent *)theEvent{
//    NSLog(@"%s",__func__);
    [self mouseMoved:theEvent];
}

- (void)mouseMoved:(NSEvent *)theEvent{
//    NSLog(@"%s",__func__);
    NSPoint location = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    BOOL resizingCursor = NO;
    NSUInteger dividerCnt = [self numberOfDivider];
    for (NSInteger i = 0; i < dividerCnt; i++){
        NSRect rcDivider = [self rectOfDividerAtIndex:i];
        if(NSPointInRect(location, rcDivider)){
            resizingCursor = YES;
            break;
        }
    }
    if (resizingCursor){
        [self setResizingCursor];
    }
    else{
        [self setNormalCursor];
    }
}

- (void)mouseExited:(NSEvent *)theEvent{
//    NSLog(@"%s",__func__);
    [self setNormalCursor];
}
#pragma mark cursor
- (void)setNormalCursor{
    [super resetCursorRects];
    NSCursor *theCursor = [NSCursor arrowCursor];
    [self addCursorRect:[self bounds] cursor:theCursor];
    [theCursor set];
}
- (void)setResizingCursor{
    [super resetCursorRects];
    NSCursor* theCursor = _vertical?[NSCursor resizeLeftRightCursor]:[NSCursor resizeUpDownCursor];
    [self addCursorRect:[self bounds] cursor:theCursor];
    [theCursor set];
}
#pragma mark override
- (BOOL)isFlipped{
    return YES;
}
@end
