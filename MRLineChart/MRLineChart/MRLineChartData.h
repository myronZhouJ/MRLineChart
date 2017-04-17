//
//  MRLineChartData.h
//  StoryBoard
//
//  Created by Myron on 3/15/17.
//  Copyright © 2017 Wishnote. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRLineChartData : NSObject
@property(nonatomic,strong)NSArray *XScaleArr;
@property(nonatomic,strong)NSArray *YScaleArr;
@property(nonatomic,strong)NSArray *lineValues;
@property(nonatomic,strong)NSArray *barValues;
@end
