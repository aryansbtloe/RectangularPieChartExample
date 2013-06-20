//
//  AksStraightPieChart.h
//  Betify
//
//  Created by Alok on 19/06/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AksStraightPieChart : UIView
{
    NSMutableArray *dataToRepresent;
}

- (void)addDataToRepresent:(int)value WithColor:(UIColor *)color;
- (void)clearChart;

@end
