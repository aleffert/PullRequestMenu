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

- (NSColor*)backgroundColor {
    return NSColor.labelColor;
}

- (void)drawRect:(NSRect)dirtyRect {
    CGFloat pillHeight = 16;
    CGRect backgroundRect = CGRectMake(2, (self.bounds.size.height - pillHeight) / 2, self.bounds.size.width - 4, pillHeight);
    NSBezierPath* bezierPath = [NSBezierPath bezierPathWithRoundedRect:backgroundRect xRadius:8 yRadius:8];
    [[self backgroundColor] setFill];
    [bezierPath fill];

    if(self.text != nil) {
        NSGraphicsContext* context = [NSGraphicsContext currentContext];
        [context saveGraphicsState];
        // Punch the text out of the pill so the menu bar shows through the digits.
        context.compositingOperation = NSCompositingOperationDestinationOut;

        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSAttributedString* text = [[NSAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName: self.font, NSForegroundColorAttributeName : [NSColor blackColor], NSParagraphStyleAttributeName : paragraphStyle}];
        CGFloat textHeight = text.size.height;
        CGRect textRect = CGRectMake(0, (self.bounds.size.height - textHeight) / 2, self.bounds.size.width, textHeight);
        [text drawInRect:textRect];

        [context restoreGraphicsState];
    }
}

- (void)viewDidChangeEffectiveAppearance {
    [self setNeedsDisplay:YES];
}

// Let clicks fall through to the status item's button, which shows the menu automatically.
- (NSView*)hitTest:(NSPoint)point {
    return nil;
}

- (void)setText:(NSString *)text {
    _text = text;

    CGFloat textWidth = [self.text sizeWithAttributes:@{NSFontAttributeName : self.font}].width;
    CGFloat width = MAX(20, ceil(textWidth + 11));
    self.item.length = width;

    [self setNeedsDisplay:YES];
}

@end
