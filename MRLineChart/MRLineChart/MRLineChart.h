//
//  MRLineChart.h
//  StoryBoard
//
//  Created by Myron on 3/15/17.
//  Copyright © 2017 Wishnote. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MRLineChartData,MRLineChart,MRLineChartValueDataItem;

@protocol MRLineChartDelegate <NSObject>
-(UIView*)boardViewMRLineChart:(MRLineChart*)lineChart;
-(void)interactingMRLineChart:(MRLineChart*)lineChart boardView:(UIView*)boardView focusValue:(MRLineChartValueDataItem*)focus;
@end

@interface MRLineChart : UIView
@property(nonatomic,strong) MRLineChartData *lineChartData;
@property(nonatomic,strong) UIColor *dataLineColor;
@property(nonatomic) CGFloat dataLineWidth;

@property(nonatomic,strong) UIColor * bottomScaleLineColor;
@property(nonatomic) CGFloat bottomScaleLineWidth;

@property(nonatomic,strong) UIColor *scaleLineColor;
@property(nonatomic) CGFloat scaleLineWidth;

@property(nonatomic,strong) UIColor *scaleTextColor;
@property(nonatomic,strong) UIFont *scaleTextFont;

@property(nonatomic) CGFloat marginRight;
@property(nonatomic) CGFloat marginTop;
@property(nonatomic) CGFloat marginLeft;
@property(nonatomic) CGFloat marginBottom;

@property(nonatomic) CGFloat barChartItemWidth;
@property(nonatomic) UIColor *barChartItemColor;

@property(nonatomic) CGFloat indictorWidth;
@property(nonatomic, strong) UIColor *indictorColor;

@property (nonatomic,weak) id<MRLineChartDelegate> delegate;

-(void)repaint;
@end
