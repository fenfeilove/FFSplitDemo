//
//  FFMainWindowController.m
//  FFSplitDemo
//
//  Created by francis zhuo on 2017/8/18.
//  Copyright © 2017年 fenfei. All rights reserved.
//

#import "FFMainWindowController.h"
#import "FFVideoView.h"
#import "FFPanelView.h"
#import "FFSplitView.h"

static NSString*    zFFViewToolbarIdentifier         = @"Toolbar Identifier View";
@interface FFMainWindowController ()<NSSplitViewDelegate,NSToolbarDelegate>

@end

@implementation FFMainWindowController
- (id)init{
    self = [super init];
    if(self){
        NSRect rcWindow = NSMakeRect(300, 200, 100, 100);
        self.window = [[[NSWindow alloc] initWithContentRect:rcWindow styleMask:NSWindowStyleMaskTitled|NSWindowStyleMaskClosable|NSWindowStyleMaskResizable|NSWindowStyleMaskMiniaturizable backing:NSBackingStoreBuffered defer:NO] autorelease];
        [self initLayoutButtons];
        [self initToolbar];
        [self initSubView];
    }
    return self;
}
- (void)initLayoutButtons{
    _layoutButtons = [[NSSegmentedControl alloc] init];
    [_layoutButtons setSegmentCount:3];
    [_layoutButtons setSegmentStyle:NSSegmentStyleRounded];
    [_layoutButtons setImage:[NSImage imageNamed:@"share_wall"] forSegment:0];
    [_layoutButtons setImage:[NSImage imageNamed:@"share_wall"] forSegment:1];
    [_layoutButtons setImage:[NSImage imageNamed:@"share_wall"] forSegment:2];
    [_layoutButtons setLabel:@"share wall" forSegment:0];
    [_layoutButtons sizeToFit];
    [_layoutButtons setTarget:self];
    [_layoutButtons setAction:@selector(onLayoutClick:)];
}
- (void)onLayoutClick:(id)sender{
    NSLog(@"(%@)",sender);
}
- (void)initToolbar{
    NSToolbar* toolbar = [[[NSToolbar alloc] initWithIdentifier:@"kFFMainWindowToolbar"] autorelease];
    [toolbar setAllowsUserCustomization:YES];
    [toolbar setAutosavesConfiguration:NO];
    [toolbar setDisplayMode:NSToolbarDisplayModeIconOnly];
    [toolbar setSizeMode:NSToolbarSizeModeSmall];
    
    [toolbar setDelegate:self];
    [self.window setToolbar:toolbar];
}
- (void)initSubView{
    NSView* contentView = [self.window contentView];
    
    _splitView = [[FFSplitView alloc] init];
    _splitView.vertical = YES;
    _splitView.dividerPointColor = [NSColor redColor];
    _splitView.dividerBackgroundColor = [NSColor yellowColor];
    _splitView.dividerWidth = 9.f;
    _splitView.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:_splitView];

    NSLayoutConstraint* top = [NSLayoutConstraint constraintWithItem:_splitView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [contentView addConstraint:top];
    NSLayoutConstraint* lead = [NSLayoutConstraint constraintWithItem:_splitView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    [contentView addConstraint:lead];
    NSLayoutConstraint* centerX = [NSLayoutConstraint constraintWithItem:_splitView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [contentView addConstraint:centerX];
    NSLayoutConstraint* centerY = [NSLayoutConstraint constraintWithItem:_splitView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [contentView addConstraint:centerY];
//    NSLayoutConstraint* Bottom = [NSLayoutConstraint constraintWithItem:_splitView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
//    [contentView addConstraint:Bottom];
//
    FFVideoView* videoView = [[FFVideoView alloc] init];
    [_splitView addSubview:videoView];
    [_splitView setMinimumWidth:400 forView:videoView];
    [_splitView setMinimumHeight:200.f forView:videoView];
    
    videoView = [[FFVideoView alloc] init];
    [_splitView addSubview:videoView];
    [_splitView setMinimumWidth:200 forView:videoView];
    [_splitView setMaximumWidth:400 forView:videoView];
    
    videoView = [[FFVideoView alloc] init];
    [_splitView addSubview:videoView];
    [_splitView setMinimumWidth:200 forView:videoView];
    
    FFSplitView* _splitView2 = [[FFSplitView alloc] init];
    _splitView2.translatesAutoresizingMaskIntoConstraints = NO;
    _splitView2.vertical = NO;
    _splitView2.dividerPointColor = [NSColor redColor];
    _splitView2.dividerBackgroundColor = [NSColor blueColor];
    _splitView2.dividerWidth = 9.f;
    [videoView addSubview:_splitView2];
    NSArray*  constraints= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[splitview2]|" options:0 metrics:nil views:@{@"splitview2":_splitView2}];
    [videoView addConstraints:constraints];
    constraints= [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[splitview2]|" options:0 metrics:nil views:@{@"splitview2":_splitView2}];
    [videoView addConstraints:constraints];
    
    videoView = [[FFVideoView alloc] init];
    [_splitView2 addSubview:videoView];
    [_splitView2 setMinimumHeight:200 forView:videoView];
    
    videoView = [[FFVideoView alloc] init];
    [_splitView2 addSubview:videoView];
    [_splitView2 setMinimumHeight:50 forView:videoView];
    
//    videoView = [[FFVideoView alloc] init];
//    [_splitView addSubview:videoView];
//    [_splitView setMinimumWidth:100 forView:videoView];

//    FFPanelView* panelView = [[FFPanelView alloc] init];
//    panelView.translatesAutoresizingMaskIntoConstraints = NO;
//    [_splitView addSubview:panelView];
////    height  = [NSLayoutConstraint constraintWithItem:panelView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:400];
////    [panelView addConstraint:height];
//
//    FFSplitView* splitView = [[FFSplitView alloc] init];
//    splitView.translatesAutoresizingMaskIntoConstraints = NO;
//    [_splitView addSubview:splitView];
    
    
}

//- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex{
//    if(dividerIndex==0){
//        if(proposedMinimumPosition < 50)
//            proposedMinimumPosition = 0;
//        else if(proposedMinimumPosition < 200)
//            proposedMinimumPosition = 200;
//        return proposedMinimumPosition;
//    }
//    return proposedMinimumPosition;
//}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar
{
    return @[NSToolbarSpaceItemIdentifier,NSToolbarFlexibleSpaceItemIdentifier,zFFViewToolbarIdentifier];
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar
{
    return @[NSToolbarFlexibleSpaceItemIdentifier,zFFViewToolbarIdentifier];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
    NSToolbarItem* toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier] autorelease];
    if([itemIdentifier isEqualToString:zFFViewToolbarIdentifier]){
        toolbarItem.label = @"view";
        toolbarItem.paletteLabel = @"view";
        toolbarItem.toolTip = @"layout";
        toolbarItem.view = _layoutButtons;
    }
    return toolbarItem;
}
@end
