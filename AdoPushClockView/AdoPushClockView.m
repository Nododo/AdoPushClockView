//
//  NEPushClockView.m
//  123
//
//  Created by coohua on 16/12/9.
//  Copyright © 2016年 coohua. All rights reserved.
//

#import "AdoPushClockView.h"
#import "Masonry.h"

@implementation AdoPushClockModel


@end

#define kRGBA(r, g, b, a)  [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]


@interface AdoPushClockView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,assign) int  minHour;
@property (nonatomic,assign) int  maxHour;
@property (nonatomic,assign) AdoAlarmFrequencyType  delta;

@property (nonatomic,strong) NSMutableArray *minHours;
@property (nonatomic,strong) NSMutableArray *maxHours;
@property (nonatomic,strong) NSMutableArray *deltas;


@property (nonatomic, weak) UIPickerView *picker;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UIView *topLine;

@property (nonatomic, weak) UIView *bottomLine;

@end

@implementation AdoPushClockView

- (instancetype)initWithFrame:(CGRect)frame minHour:(int)minHour maxHour:(int)maxHour delta:(AdoAlarmFrequencyType)delta {
    self = [super initWithFrame:frame];
    if (self) {
        self.minHour = minHour;
        self.maxHour = maxHour;
        self.delta = delta;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UILabel *titleLabel = [[UILabel alloc] init];
    NSString *minHour = [NSString stringWithFormat:@"%02d:00",self.minHour];
    NSString *maxHour = [NSString stringWithFormat:@"%02d:00",self.maxHour];
    titleLabel.text = [NSString stringWithFormat:@"%@至%@   %@/次",minHour, maxHour, self.deltas[self.delta]];
    titleLabel.textColor = kRGBA(254, 55, 16, 1);
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = kRGBA(0xDC, 0xDC, 0xDC, 1);
    [self addSubview:topLine];
    self.topLine = topLine;
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = kRGBA(0xDC, 0xDC, 0xDC, 1);
    [self addSubview:bottomLine];
    self.bottomLine = bottomLine;
    
    
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.dataSource = self;
    picker.delegate = self;
    [self addSubview:picker];
    self.picker = picker;
    
    [self.picker selectRow:[self indexForHour:self.minHour atArray:self.minHours] inComponent:0 animated:NO];
    [self.picker selectRow:[self indexForHour:self.maxHour atArray:self.maxHours] inComponent:1 animated:NO];
    [self.picker selectRow:self.delta inComponent:2 animated:NO];
}


- (void)layoutSubviews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(30);
    }];
    
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.titleLabel);
        make.height.mas_equalTo(1);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.titleLabel);
        make.height.mas_equalTo(1);
    }];
    
    
    [self.picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.bottom.equalTo(self);
    }];
    
    [super layoutSubviews];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return self.minHours.count;
            break;
        case 1:
            return self.maxHours.count;
            break;
        case 2:
            return self.deltas.count;
            break;
        default:
            break;
    }
    return 0;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    
    switch (component) {
        case 0:
            label.text = self.minHours[row];
            break;
        case 1:
            label.text = self.maxHours[row];
            break;
        case 2:
            label.text = self.deltas[row];
            break;
        default:
            break;
    }
    return label;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self handleRow:row inComponent:component];
}

- (void)handleRow:(NSInteger)row inComponent:(NSInteger)component{
    NSInteger firstRow = [self.picker selectedRowInComponent:0];
    NSInteger secondRow =[self.picker selectedRowInComponent:1];
    
    if (component == 0) {
        if (firstRow >= secondRow) {
            [self.picker selectRow:firstRow inComponent:1 animated:YES];
        }
    } else if (component == 1){
        if (firstRow >= secondRow) {
            [self.picker selectRow:secondRow inComponent:0 animated:YES];
        }
    }
    
    //重新获取选中的row
    NSInteger newFirstRow = [self.picker selectedRowInComponent:0];
    NSInteger newSecondRow =[self.picker selectedRowInComponent:1];
    NSInteger newFhirdRow =[self.picker selectedRowInComponent:2];
    
    int firstValue = [self.minHours[newFirstRow] intValue];
    int secondValue = [self.maxHours[newSecondRow] intValue];
    float thirdValue = [self.deltas[newFhirdRow] floatValue];
    
    int distance = secondValue - firstValue;
    if (distance < thirdValue) {
        [self.picker selectRow:[self rowForDistance:distance] inComponent:2 animated:YES];
    }
    
    [self configValue];
}

- (void)configValue {
    NSInteger firstRow = [self.picker selectedRowInComponent:0];
    NSInteger secondRow = [self.picker selectedRowInComponent:1];
    NSInteger thirdRow = [self.picker selectedRowInComponent:2];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@至%@   %@/次",self.minHours[firstRow], self.maxHours[secondRow], self.deltas[thirdRow]];
}

#pragma mark -懒加载部分

- (NSMutableArray *)minHours {
    if (!_minHours) {
        self.minHours = [NSMutableArray array];
        for (int i = 0; i < 24; i ++) {
            NSString *minHour = [NSString stringWithFormat:@"%02d:00",i];
            [_minHours addObject:minHour];
        }
    }
    return _minHours;
}


- (NSMutableArray *)maxHours {
    if (!_maxHours) {
        self.maxHours = [NSMutableArray array];
        for (int i = 1; i < 25; i ++) {
            NSString *minHour = [NSString stringWithFormat:@"%02d:00",i];
            [_maxHours addObject:minHour];
        }
    }
    return _maxHours;
}

- (NSMutableArray *)deltas {
    if (!_deltas) {
        self.deltas = [NSMutableArray array];
        [_deltas addObject:@"0.5小时"];
        [_deltas addObject:@"1小时"];
        [_deltas addObject:@"3小时"];
        [_deltas addObject:@"5小时"];
    }
    return _deltas;
}

#pragma mark - 辅助方法

- (NSInteger)indexForHour:(int)hour atArray:(NSArray *)array {
    for (int i = 0; i < array.count; i ++) {
        if (hour == [array[i] intValue]) {
            return i;
        }
    }
    return 0;
}

- (NSInteger)rowForDistance:(int)distance {
    for (int  i = (self.deltas.count - 1); i >= 0; i --) {
        float delta = [self.deltas[i] floatValue];
        if (distance >= delta) {
            return i;
        }
    }
    return 0;
}

#pragma mark - 获取当前时间

- (AdoPushClockModel *)currentModel {
    NSInteger firstRow = [self.picker selectedRowInComponent:0];
    NSInteger secondRow = [self.picker selectedRowInComponent:1];
    NSInteger thirdRow = [self.picker selectedRowInComponent:2];
    
    
    AdoPushClockModel *model = [[AdoPushClockModel alloc] init];
    model.minHour = [self.minHours[firstRow] intValue];
    model.maxHour = [self.maxHours[secondRow] intValue];
    model.tyoe = thirdRow;
    return model;
}
@end
