//
//  NEPushClockView.h
//  123
//
//  Created by coohua on 16/12/9.
//  Copyright © 2016年 coohua. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AdoAlarmFrequencyType) {
    AdoAlarmFrequencyTypeHalfAnHour = 0, //半小时
    AdoAlarmFrequencyTypeHour,//1小时
    AdoAlarmFrequencyTypeThreeHour,//3小时
    AdoAlarmFrequencyTypeFiveHour//5小时
};


@interface AdoPushClockModel : NSObject

@property (nonatomic, assign) int minHour;//最小钟点
@property (nonatomic, assign) int maxHour;//最大钟点
@property (nonatomic, assign) AdoAlarmFrequencyType tyoe;//时间差值  枚举值

@end



@interface AdoPushClockView : UIView

- (instancetype)initWithFrame:(CGRect)frame minHour:(int)minHour maxHour:(int)maxHour delta:(AdoAlarmFrequencyType)delta;


/**
 获取当前时间的模型

 @return 模型
 */
- (AdoPushClockModel *)currentModel;

@end
