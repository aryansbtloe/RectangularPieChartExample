//
//  ExampleViewController.m
//  RectangularPieChartExample
//
//  Created by Alok on 20/06/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import "ExampleViewController.h"
#import "AksStraightPieChart.h"

@interface ExampleViewController ()

@end

@implementation ExampleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.



	CGRect screenRect = [[UIScreen mainScreen]bounds];

	AksStraightPieChart * straightPieChart = [[AksStraightPieChart alloc]initWithFrame:CGRectInset(screenRect,screenRect.size.width/6,screenRect.size.height/2-20)];
	[[self view]addSubview:straightPieChart];

	[straightPieChart clearChart];
    [straightPieChart addDataToRepresent:35 WithColor:[UIColor colorWithRed:0.178 green:0.709 blue:0.106 alpha:1.000]];
    [straightPieChart addDataToRepresent:45 WithColor:[UIColor colorWithWhite:0.379 alpha:1.000]];
    [straightPieChart addDataToRepresent:20 WithColor:[UIColor colorWithRed:0.971 green:0.000 blue:0.088 alpha:1.000]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
