//
//  ViewController.m
//  AdoPushClockView
//
//  Created by coohua on 16/12/9.
//
//

#import "ViewController.h"
#import "AdoPushClockView.h"

@interface ViewController ()

@property (nonatomic, strong) AdoPushClockView *clockView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AdoPushClockView  *view = [[AdoPushClockView alloc] initWithFrame:CGRectMake(0, 100, 375, 200) minHour:9 maxHour:10 delta:0];
    [self.view addSubview:view];
    self.clockView = view;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    AdoPushClockModel *model =  [self.clockView currentModel];
    NSLog(@"min = %d max = %d type = %d", model.minHour, model.maxHour , model.tyoe);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
