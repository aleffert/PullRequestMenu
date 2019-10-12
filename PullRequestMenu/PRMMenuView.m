//
//  PRMMenuView.m
//  PullRequestMenu
//
//  Created by Akiva Leffert on 9/15/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "PRMMenuView.h"

@interface PRMMenuView ()

@property (weak, nonatomic) NSStatusItem* item;
@property (assign, nonatomic) BOOL highlighted;
@property (strong, nonatomic) NSFont* font;

@end

@implementation PRMMenuView

- (id)initWithFrame:(NSRect)frameRect statusItem:(NSStatusItem*)item {
    self = [super initWithFrame:frameRect];
    if(self != nil) {
        self.font = [NSFont fontWithName:@"HelveticaNeue-Medium" size:12];
        self.item = item;
    }
    
    return self;
}

- (BOOL)isOpaque {
    return NO;
}

- (NSColor*)foregroundColor {
    return NSColor.textBackgroundColor;
}

- (NSColor*)backgroundColor {
    return NSColor.labelColor;
}

- (void)drawRect:(NSRect)dirtyRect {
    [self.item drawStatusBarBackgroundInRect:dirtyRect withHighlight:self.highlighted];
    
    CGRect backgroundRect = CGRectMake(2, 2, self.bounds.size.width - 4, 16);
    NSBezierPath* bezierPath = [NSBezierPath bezierPathWithRoundedRect:backgroundRect xRadius:8 yRadius:8];
    [[self backgroundColor] setFill];
    [bezierPath fill];
    
    if(self.text != nil) {
        NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName: self.font, NSForegroundColorAttributeName : [self foregroundColor]}];
        [text setAlignment:NSCenterTextAlignment range:NSMakeRange(0, text.length)];
        [text drawInRect:self.bounds];
    }
}

- (void)viewDidChangeEffectiveAppearance {
    [self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)theEvent {
    self.item.menu.delegate = self;
    [self.item popUpStatusItemMenu:self.item.menu];
}

- (void)setHighlighted:(BOOL)highlighted {
    _highlighted = highlighted;
    [self setNeedsDisplay:YES];
}

- (void)menuWillOpen:(NSMenu *)menu {
    self.highlighted = YES;
}

- (void)menuDidClose:(NSMenu *)menu {
    self.highlighted = NO;
}

- (void)setText:(NSString *)text {
    _text = text;
    
    CGFloat textWidth = [self.text sizeWithAttributes:@{NSFontAttributeName : self.font}].width;
    CGFloat width = MAX(20, ceil(textWidth + 11));
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
    
    [self setNeedsDisplay:YES];
}

@end
