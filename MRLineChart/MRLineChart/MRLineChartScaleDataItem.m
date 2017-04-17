//
//  MRLineChartScaleDataItem.m
//  StoryBoard
//
//  Created by Myron on 3/15/17.
//  Copyright © 2017 Wishnote. All rights reserved.
//

#import "MRLineChartScaleDataItem.h"

@implementation MRLineChartScaleDataItem
-(instancetype)initWithName:(NSString *)name value:(CGFloat)value{
    
    self = [super init];
    if (self) {
        _name = [name copy];
        _value = MIN(1.0, MAX(0, value));
    }
    return self;
}

+(instancetype)itemWithName:(NSString *)name value:(CGFloat)value{
    MRLineChartScaleDataItem *item = [[MRLineChartScaleDataItem alloc] initWithName:name value:value];
    return item;
}
@end
