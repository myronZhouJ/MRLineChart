//
//  MRLineChartScaleDataItem.h
//  StoryBoard
//
//  Created by Myron on 3/15/17.
//  Copyright © 2017 Wishnote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MRLineChartScaleDataItem : NSObject
@property(nonatomic,readonly)NSString *name;
@property(nonatomic,readonly)CGFloat value;

+(instancetype)itemWithName:(NSString*)name value:(CGFloat)value;
@end
