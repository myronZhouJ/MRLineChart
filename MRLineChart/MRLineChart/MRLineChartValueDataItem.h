//
//  MRLineChartValueDataItem.h
//  StoryBoard
//
//  Created by Myron on 3/15/17.
//  Copyright © 2017 Wishnote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MRLineChartValueDataItem : NSObject
@property(nonatomic,readonly)CGFloat xValue;
@property(nonatomic,readonly)CGFloat yValue;

+(instancetype)itemWithXValue:(CGFloat)xValue YValue:(CGFloat)yValue;
@end
