//
//  ViewController.m
//  MRLineChart
//
//  Created by Myron on 4/17/17.
//  Copyright © 2017 Pikicast. All rights reserved.
//

#import "ViewController.h"
#import "MRLineChart.h"
#import "MRLineChartData.h"
#import "MRLineChartScaleDataItem.h"
#import "MRLineChartValueDataItem.h"
#import "BoardView.h"

#define RGBCOLOR(r,g,b) ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1])

@interface ViewController () <MRLineChartDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [self MRLineChartInit];
}

-(void)MRLineChartInit{
    
    MRLineChartData *data = [[MRLineChartData alloc] init];
    data.XScaleArr = [NSArray arrayWithObjects:[MRLineChartScaleDataItem itemWithName:@"1x" value:0.1],
                      [MRLineChartScaleDataItem itemWithName:@"2x" value:0.2],
                      [MRLineChartScaleDataItem itemWithName:@"3x" value:0.3],
                      [MRLineChartScaleDataItem itemWithName:@"4x" value:0.4],
                      [MRLineChartScaleDataItem itemWithName:@"5x" value:0.5],
                      [MRLineChartScaleDataItem itemWithName:@"6x" value:0.6],
                      [MRLineChartScaleDataItem itemWithName:@"7x" value:0.7],
                      [MRLineChartScaleDataItem itemWithName:@"8x" value:0.8],
                      [MRLineChartScaleDataItem itemWithName:@"9x" value:0.9],
                      [MRLineChartScaleDataItem itemWithName:@"10x" value:1.0],
                      nil];
    
    data.YScaleArr = [NSArray arrayWithObjects:[MRLineChartScaleDataItem itemWithName:@"1y" value:0.1],
                      [MRLineChartScaleDataItem itemWithName:@"2y" value:0.2],
                      [MRLineChartScaleDataItem itemWithName:@"3y" value:0.3],
                      [MRLineChartScaleDataItem itemWithName:@"4y" value:0.4],
                      [MRLineChartScaleDataItem itemWithName:@"5y" value:0.5],
                      [MRLineChartScaleDataItem itemWithName:@"6y" value:0.6],
                      [MRLineChartScaleDataItem itemWithName:@"7y" value:0.7],
                      [MRLineChartScaleDataItem itemWithName:@"8y" value:0.8],
                      [MRLineChartScaleDataItem itemWithName:@"9y" value:0.9],
                      [MRLineChartScaleDataItem itemWithName:@"10y" value:1.0],
                      nil];
    
    data.lineValues = [NSArray arrayWithObjects:[MRLineChartValueDataItem itemWithXValue:0.03 YValue:0.45],
                       [MRLineChartValueDataItem itemWithXValue:0.10 YValue:0.3],
                       [MRLineChartValueDataItem itemWithXValue:0.15 YValue:0.15],
                       [MRLineChartValueDataItem itemWithXValue:0.2 YValue:0.05],
                       [MRLineChartValueDataItem itemWithXValue:0.24 YValue:0.3],
                       [MRLineChartValueDataItem itemWithXValue:0.3 YValue:0.55],
                       [MRLineChartValueDataItem itemWithXValue:0.35 YValue:0.45],
                       [MRLineChartValueDataItem itemWithXValue:0.4 YValue:0.42],
                       [MRLineChartValueDataItem itemWithXValue:0.4 YValue:0.42],
                       [MRLineChartValueDataItem itemWithXValue:0.5 YValue:0.32],
                       [MRLineChartValueDataItem itemWithXValue:0.56 YValue:0.30],
                       [MRLineChartValueDataItem itemWithXValue:0.6 YValue:0.58],
                       [MRLineChartValueDataItem itemWithXValue:0.7 YValue:0.64],
                       [MRLineChartValueDataItem itemWithXValue:0.74 YValue:0.54],
                       [MRLineChartValueDataItem itemWithXValue:0.8 YValue:0.86],
                       [MRLineChartValueDataItem itemWithXValue:0.9 YValue:0.73],
                       [MRLineChartValueDataItem itemWithXValue:0.94 YValue:0.95],
                       [MRLineChartValueDataItem itemWithXValue:1.0 YValue:1.0],
                       nil];
    
    NSMutableArray *array = [NSMutableArray array];
    for(NSInteger i = 1;i < 50;i++){
        [array addObject:[MRLineChartValueDataItem itemWithXValue:0.02*i YValue:0.2 + (random()%5)/11.0] ];
    }
    data.barValues = array;
    
    
    //----------------------------------------------------------
    MRLineChart *lineChart = [[MRLineChart alloc] initWithFrame:CGRectMake(50, 50, self.view.bounds.size.width - 100, self.view.bounds.size.height - 100)];
    lineChart.backgroundColor = RGBCOLOR(35, 37, 40);
    
    lineChart.dataLineColor = RGBCOLOR(62, 151, 189);
    lineChart.dataLineWidth = 2.5;
    
    lineChart.bottomScaleLineWidth = 1.5;
    lineChart.bottomScaleLineColor = RGBCOLOR(140, 140, 140);
    
    lineChart.scaleLineColor = RGBCOLOR(65, 65, 65);
    lineChart.scaleLineWidth = 1;
    
    lineChart.scaleTextColor = RGBCOLOR(120, 120, 120);
    lineChart.scaleTextFont = [UIFont systemFontOfSize:12];
    
    lineChart.marginTop = 10;
    lineChart.marginRight = 40;
    lineChart.marginLeft = 10;
    lineChart.marginBottom = 25;
    
    lineChart.barChartItemWidth = 3;
    lineChart.barChartItemColor = RGBCOLOR(51, 52, 56);
    
    lineChart.indictorWidth = 10;
    lineChart.indictorColor = RGBCOLOR(62, 151, 189);
    
    lineChart.lineChartData = data;
    lineChart.delegate = self;
    [self.view addSubview:lineChart];
    
    [lineChart repaint];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark MRLineChartDelegate

-(UIView*)boardViewMRLineChart:(MRLineChart*)lineChart{
    BoardView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([BoardView class]) owner:nil options:nil] firstObject];
    return view;
}

-(void)interactingMRLineChart:(MRLineChart*)lineChart boardView:(UIView*)boardView focusValue:(MRLineChartValueDataItem *)focus{
    BoardView *view = (BoardView*)boardView;
    view.valueLabel.text = @"115.87";
    view.dateLabel.text = @"(10/25)";
}

@end
