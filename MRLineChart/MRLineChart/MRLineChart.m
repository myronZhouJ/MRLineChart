//
//  MRLineChart.m
//  StoryBoard
//
//  Created by Myron on 3/15/17.
//  Copyright © 2017 Wishnote. All rights reserved.
//

#import "MRLineChart.h"
#import "MRLineChartData.h"
#import "MRLineChartScaleDataItem.h"
#import "MRLineChartValueDataItem.h"

@interface MRLineChart ()
@property(nonatomic,strong) UIPanGestureRecognizer *panGesture;
@property(nonatomic,strong) CALayer *indictorLayer;
@property(nonatomic,strong) UIView *boardView;
@property(nonatomic,strong) NSMutableArray *chartSublayers;
@end

@implementation MRLineChart

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.chartSublayers = [NSMutableArray array];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
        panGesture.delegate = (id <UIGestureRecognizerDelegate>)self;
        panGesture.enabled = NO;
        [self addGestureRecognizer:panGesture];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        tapGesture.delegate = (id <UIGestureRecognizerDelegate>)self;
        tapGesture.enabled = NO;
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//
//}

-(void)repaint{
    [self.boardView removeFromSuperview];
    self.boardView = nil;
    
    [self.indictorLayer removeFromSuperlayer];
    self.indictorLayer = nil;

    [self.chartSublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.chartSublayers removeAllObjects];
    
    if (self.lineChartData) {
        [self paintBars];
        [self paintCoordinateSystem];
        [self paintLines];
        
        for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
            gesture.enabled = YES;
        }
        
        if (!self.indictorLayer) {
            self.indictorLayer  = [[CALayer alloc] init];
            self.indictorLayer.frame = CGRectMake(0, 0, self.indictorWidth, self.indictorWidth);
            self.indictorLayer.backgroundColor = [self.indictorColor CGColor];
            self.indictorLayer.cornerRadius = self.indictorWidth/2.0;
            self.indictorLayer.shadowOffset = CGSizeMake(0, 2);
            self.indictorLayer.shadowRadius = 3;
            self.indictorLayer.shadowColor = [UIColor blackColor].CGColor;
            self.indictorLayer.shadowOpacity = .7;
            [self.layer addSublayer:self.indictorLayer];
            self.indictorLayer.hidden = YES;
        }
        
        if (!self.boardView && [self.delegate respondsToSelector:@selector(boardViewMRLineChart:)]) {
            self.boardView = [self.delegate boardViewMRLineChart:self];
            self.boardView.hidden = YES;
            self.boardView.center = CGPointMake(0, 0);
            [self addSubview:self.boardView];
        }
    }
}

-(CGPoint)pointFromChartValue:(CGFloat) xValue YValue:(CGFloat) yValue{
    CGFloat chartHeight = self.bounds.size.height - self.marginTop - self.marginBottom;
    CGFloat chartWidth = self.bounds.size.width - self.marginRight - self.marginLeft;
    
    return CGPointMake(self.marginLeft + chartWidth*xValue, self.bounds.size.height - (self.marginBottom + chartHeight*yValue));
}

-(MRLineChartValueDataItem*)chartValueFromPoint:(CGPoint)point{
    CGFloat chartHeight = self.bounds.size.height - self.marginTop - self.marginBottom;
    CGFloat chartWidth = self.bounds.size.width - self.marginRight - self.marginLeft;
    
    return [MRLineChartValueDataItem itemWithXValue:MIN(1.0, MAX(0, (point.x - self.marginLeft)/chartWidth)) YValue:MIN(1.0, MAX(0, (self.bounds.size.height - point.y - self.marginBottom)/chartHeight))];
}

-(CGRect)barRectWithXValue:(CGFloat) xValue YValue:(CGFloat) yValue{
    CGFloat chartWidth = self.bounds.size.width - self.marginRight - self.marginLeft;
    CGFloat chartHeight = self.bounds.size.height - self.marginTop - self.marginBottom;
    CGFloat barWidth = self.barChartItemWidth;
    
    return  CGRectMake(self.marginLeft + chartWidth * xValue - barWidth/2.0, self.bounds.size.height - (self.marginBottom + chartHeight * yValue), barWidth, chartHeight * yValue);
}

-(CATextLayer*)scaleTextLayer{
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.foregroundColor = self.scaleTextColor.CGColor;
    CGFontRef fontRef = CGFontCreateWithFontName((__bridge CFStringRef)self.scaleTextFont.fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = self.scaleTextFont.pointSize;
    CGFontRelease(fontRef);
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    return textLayer;
}

//画坐标系统
-(void)paintCoordinateSystem;
{
    CGSize size = self.bounds.size;
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:[self pointFromChartValue:0 YValue:0]];
    [linePath addLineToPoint:CGPointMake(size.width,[self pointFromChartValue:1 YValue:0].y)];
    
    CAShapeLayer *bottomlineLayer = [CAShapeLayer layer];
    bottomlineLayer.path = linePath.CGPath;
    bottomlineLayer.lineWidth = self.bottomScaleLineWidth;
    bottomlineLayer.strokeColor = [self.bottomScaleLineColor CGColor];
    [self.layer addSublayer:bottomlineLayer];
    [self.chartSublayers addObject:bottomlineLayer];
    
    linePath = [UIBezierPath bezierPath];
    
    for (MRLineChartScaleDataItem *YItem in  self.lineChartData.YScaleArr) {
        [linePath moveToPoint:[self pointFromChartValue:0 YValue:YItem.value]];
        [linePath addLineToPoint:[self pointFromChartValue:1 YValue:YItem.value]];
    }
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.path = linePath.CGPath;
    lineLayer.lineWidth = self.scaleLineWidth;
    lineLayer.strokeColor = [self.scaleLineColor CGColor];
    [self.layer addSublayer:lineLayer];
    [self.chartSublayers addObject:lineLayer];

    NSDictionary *scaleTextAttribute = @{NSFontAttributeName:self.scaleTextFont,NSForegroundColorAttributeName:self.scaleTextColor};
    
    for (MRLineChartScaleDataItem *YItem in  self.lineChartData.YScaleArr) {
        CGSize nameSize = [YItem.name sizeWithAttributes:scaleTextAttribute];
        CGPoint p = [self pointFromChartValue:1 YValue:YItem.value];
        CATextLayer *textLayer = [self scaleTextLayer];
        textLayer.frame = CGRectMake(p.x + 5, p.y - nameSize.height/2.0,nameSize.width,nameSize.height);
        textLayer.string = YItem.name;
        [self.layer addSublayer:textLayer];
        [self.chartSublayers addObject:textLayer];
    }
    
    for (MRLineChartScaleDataItem *xItem in  self.lineChartData.XScaleArr) {
        CGSize nameSize = [xItem.name sizeWithAttributes:scaleTextAttribute];
        CGPoint p =  [self pointFromChartValue:xItem.value YValue:0];
        CATextLayer *textLayer = [self scaleTextLayer];
        textLayer.frame = CGRectMake(p.x - nameSize.width/2.0, p.y,nameSize.width,nameSize.height);
        textLayer.string = xItem.name;
        [self.layer addSublayer:textLayer];
        [self.chartSublayers addObject:textLayer];
    }
}

//画折现图
-(void)paintLines{
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    for (MRLineChartValueDataItem *pItem in  self.lineChartData.lineValues) {
        if (pItem == [self.lineChartData.lineValues firstObject]) {
            [linePath moveToPoint:[self pointFromChartValue:pItem.xValue YValue:pItem.yValue]];
        }else{
            [linePath addLineToPoint:[self pointFromChartValue:pItem.xValue YValue:pItem.yValue]];
        }
    }
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.lineCap = kCALineCapRound;
    lineLayer.lineJoin = kCALineJoinMiter;
    lineLayer.lineWidth = self.dataLineWidth;
    lineLayer.path = linePath.CGPath;
    lineLayer.fillColor = [[UIColor clearColor] CGColor];
    lineLayer.strokeColor = [self.dataLineColor CGColor];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 0.5;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [lineLayer addAnimation:pathAnimation forKey:@"paintDataLinesAnimation"];
    [self.layer addSublayer:lineLayer];
    [self.chartSublayers addObject:lineLayer];
}

//画柱状图
-(void)paintBars{
    UIBezierPath * barsPath = [UIBezierPath bezierPath];
    for (MRLineChartValueDataItem *item in  self.lineChartData.barValues) {
        UIBezierPath *barPath  = [UIBezierPath bezierPathWithRoundedRect:[self barRectWithXValue:item.xValue YValue:item.yValue] byRoundingCorners:UIRectCornerTopRight|UIRectCornerTopLeft cornerRadii:CGSizeMake(1, 0)];
        [barsPath appendPath:barPath];
    }
    
    CAShapeLayer *barsLayer = [CAShapeLayer layer];
    barsLayer.path = barsPath.CGPath;
    barsLayer.fillColor = [self.barChartItemColor CGColor];
    barsLayer.lineWidth = 0;
    [self.layer addSublayer:barsLayer];
    [self.chartSublayers addObject:barsLayer];
}

//移动焦点layer
-(void)putIndictorToValue:(MRLineChartValueDataItem*)value{
    if (self.indictorLayer) {
        self.indictorLayer.hidden = NO;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.indictorLayer.position = [self pointFromChartValue:value.xValue YValue:value.yValue];
        [CATransaction commit];
    }
}

//移动焦点信息view
-(void)putBoardToValue:(MRLineChartValueDataItem*)value{
    if (self.boardView) {
        self.boardView.hidden = NO;
        self.boardView.center = [self pointFromChartValue:value.xValue YValue:value.yValue];
        self.boardView.layer.anchorPoint = CGPointMake(1, 0.5);
        
        CGRect boardViewRect = self.boardView.frame;
        if (boardViewRect.origin.x < 0) {
            self.boardView.layer.anchorPoint = CGPointMake(0, self.boardView.layer.anchorPoint.y);
        }
        
        if (boardViewRect.origin.y + boardViewRect.size.height > self.bounds.size.height - self.marginBottom) {
            self.boardView.layer.anchorPoint = CGPointMake(self.boardView.layer.anchorPoint.x, 1);
        }
        
        if (boardViewRect.origin.y < 0) {
            self.boardView.layer.anchorPoint = CGPointMake(self.boardView.layer.anchorPoint.x, 0);
        }
    }
}

//查找与用户焦点最近的数据项
-(void)userInteractingToPoint:(CGPoint)point{
    //用户真正焦点
    MRLineChartValueDataItem *interactionValue = [self chartValueFromPoint:point];
    
    //查找与用户焦点最近的数据项
    MRLineChartValueDataItem *pending = nil;
    for (MRLineChartValueDataItem * lineValue in self.lineChartData.lineValues) {
        if (lineValue.xValue > interactionValue.xValue) {
            if (lineValue == self.lineChartData.lineValues.firstObject) {
                pending = lineValue;
            }else{
                pending = (fabs(interactionValue.xValue - pending.xValue) < fabs(lineValue.xValue - interactionValue.xValue))?pending:lineValue;
            }
            break;
        }else{
            pending = lineValue;
        }
    }
    [self putIndictorToValue:pending];
    [self putBoardToValue:pending];
    
    if (self.boardView && [self.delegate respondsToSelector:@selector(interactingMRLineChart:boardView:focusValue:)]) {
        [self.delegate interactingMRLineChart:self boardView:self.boardView focusValue:pending];
    }
}

- (void)didTap:(UITapGestureRecognizer *)tapGesture{
    [self userInteractingToPoint:[tapGesture locationInView:self]];
}

- (void)didPan:(UIPanGestureRecognizer *)panGesture{
    if (panGesture.state == UIGestureRecognizerStateBegan || panGesture.state == UIGestureRecognizerStateChanged) {
        [self userInteractingToPoint:[panGesture locationInView:self]];
    }
}

@end
