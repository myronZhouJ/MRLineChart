//
//  MRLineChartValueDataItem.m
//  StoryBoard
//
//  Created by Myron on 3/15/17.
//  Copyright © 2017 Wishnote. All rights reserved.
//

#import "MRLineChartValueDataItem.h"

@implementation MRLineChartValueDataItem
-(instancetype)initWithXValue:(CGFloat)xValue YYalue:(CGFloat)yValue{
    
    self = [super init];
    if (self) {
        _xValue = MIN(1.0, MAX(0, xValue));
        _yValue = MIN(1.0, MAX(0, yValue));;
    }
    return self;
}

+(instancetype)itemWithXValue:(CGFloat)xValue YValue:(CGFloat)yValue{
    MRLineChartValueDataItem *item = [[MRLineChartValueDataItem alloc] initWithXValue:xValue YYalue:yValue];
    return item;
}
@end
