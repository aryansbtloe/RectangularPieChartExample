//
//  AksStraightPieChart.m
//  Betify
//
//  Created by Alok on 19/06/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import "AksStraightPieChart.h"
#import <QuartzCore/QuartzCore.h>

@implementation AksStraightPieChart

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self startUpSettings];
    }
    return self;
}

- (void)awakeFromNib {
    [self startUpSettings];
}

- (void)startUpSettings {
    dataToRepresent = [[NSMutableArray alloc]init];
    [[self layer]setCornerRadius:CGRectGetHeight([self bounds])/2];
    [[self layer]setMasksToBounds:TRUE];
    [self setBackgroundColor:[UIColor blackColor]];
}

- (void)addDataToRepresent:(int)value WithColor:(UIColor *)color {
    if (value > 0 && color && [color isKindOfClass:[UIColor class]]) {
        [dataToRepresent addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:value], @"value", color, @"color", nil]];
    } else NSLog(@"\nHey...you are passing invalid data to the aks straight pie chart...please correct it.");
}

- (void)clearChart {
    [dataToRepresent removeAllObjects];
    [self setNeedsDisplay];
}

- (void)fillRect:(CGRect)rect withColor:(CGColorRef)color onContext:(CGContextRef)currentGraphicsContext {
    CGContextAddRect(currentGraphicsContext, rect);
    CGContextSetFillColorWithColor(currentGraphicsContext, color);
    CGContextFillRect(currentGraphicsContext, rect);
}

- (void)addInnerShadowEffect {
    CGRect bounds = [self bounds];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat radius = 0.5f * CGRectGetHeight(bounds);

    // Create the "visible" path, which will be the shape that gets the inner shadow
    // In this case it's just a rounded rect, but could be as complex as your want
    CGMutablePathRef visiblePath = CGPathCreateMutable();
    CGRect innerRect = CGRectInset(bounds, radius, radius);
    CGPathMoveToPoint(visiblePath, NULL, innerRect.origin.x, bounds.origin.y);
    CGPathAddLineToPoint(visiblePath, NULL, innerRect.origin.x + innerRect.size.width, bounds.origin.y);
    CGPathAddArcToPoint(visiblePath, NULL, bounds.origin.x + bounds.size.width, bounds.origin.y, bounds.origin.x + bounds.size.width, innerRect.origin.y, radius);
    CGPathAddLineToPoint(visiblePath, NULL, bounds.origin.x + bounds.size.width, innerRect.origin.y + innerRect.size.height);
    CGPathAddArcToPoint(visiblePath, NULL,  bounds.origin.x + bounds.size.width, bounds.origin.y + bounds.size.height, innerRect.origin.x + innerRect.size.width, bounds.origin.y + bounds.size.height, radius);
    CGPathAddLineToPoint(visiblePath, NULL, innerRect.origin.x, bounds.origin.y + bounds.size.height);
    CGPathAddArcToPoint(visiblePath, NULL,  bounds.origin.x, bounds.origin.y + bounds.size.height, bounds.origin.x, innerRect.origin.y + innerRect.size.height, radius);
    CGPathAddLineToPoint(visiblePath, NULL, bounds.origin.x, innerRect.origin.y);
    CGPathAddArcToPoint(visiblePath, NULL,  bounds.origin.x, bounds.origin.y, innerRect.origin.x, bounds.origin.y, radius);
    CGPathCloseSubpath(visiblePath);

    UIColor *aColor = nil;

    // Now create a larger rectangle, which we're going to subtract the visible path from
    // and apply a shadow
    CGMutablePathRef path = CGPathCreateMutable();
    //(when drawing the shadow for a path whichs bounding box is not known pass "CGPathGetPathBoundingBox(visiblePath)" instead of "bounds" in the following line:)
    //-42 cuould just be any offset > 0
    CGPathAddRect(path, NULL, CGRectInset(bounds, -42, -42));

    // Add the visible path (so that it gets subtracted for the shadow)
    CGPathAddPath(path, NULL, visiblePath);
    CGPathCloseSubpath(path);

    // Add the visible paths as the clipping path to the context
    CGContextAddPath(context, visiblePath);
    CGContextClip(context);


    // Now setup the shadow properties on the context
    aColor = [UIColor colorWithWhite:0.000 alpha:0.700];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 1.0f), 3.0f, [aColor CGColor]);

    // Now fill the rectangle, so the shadow gets drawn
    [aColor setFill];
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextEOFillPath(context);

    // Release the paths
    CGPathRelease(path);
    CGPathRelease(visiblePath);
}

- (void)drawRect:(CGRect)rect {
    CGContextRef currentGraphicsContext = UIGraphicsGetCurrentContext();

    float sumOfAllSegmentValues = 0;

    for (int i = 0; i < dataToRepresent.count; i++) {
        sumOfAllSegmentValues += [[[dataToRepresent objectAtIndex:i] objectForKey:@"value"]intValue];
    }

    CGRect progressRect = rect;
    CGRect lastSegmentRect  = CGRectMake(0, 0, 0, 0);

    for (int i = 0; i < dataToRepresent.count; i++) {
        float currentSegmentValue = [[[dataToRepresent objectAtIndex:i] objectForKey:@"value"]intValue];
        CGColorRef color          = [[[dataToRepresent objectAtIndex:i] objectForKey:@"color"]CGColor];
        float percentage          = currentSegmentValue / sumOfAllSegmentValues;

        progressRect = rect;
        progressRect.size.width  *= percentage;
        progressRect.origin.x    += lastSegmentRect.origin.x + lastSegmentRect.size.width;

        if (progressRect.origin.x > 0) progressRect.origin.x += 0.20;

        lastSegmentRect = progressRect;

        [self fillRect:lastSegmentRect withColor:color onContext:currentGraphicsContext];
    }

    [self addInnerShadowEffect];
}

@end
