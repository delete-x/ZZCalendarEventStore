//
//  ZZViewController.m
//  ZZCalendarEventStore
//
//  Created by coder_rqb@163.com on 12/02/2020.
//  Copyright (c) 2020 coder_rqb@163.com. All rights reserved.
//

#import "ZZViewController.h"
#import <ZZCalendarEventStore.h>

@interface ZZViewController ()

@end

@implementation ZZViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [btn setTitle:@"添加事件" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(handleActionAddEvent) forControlEvents:(UIControlEventTouchUpInside)];
    btn.frame = CGRectMake(100, 100, 200, 40);
    [self.view addSubview:btn];
}

- (void)handleActionAddEvent {
    
    NSDate *startDate = [NSDate dateWithTimeInterval:300 sinceDate:[NSDate date]];
    NSDate *endDate = [NSDate dateWithTimeInterval:500 sinceDate:[NSDate date]];
    NSArray *alarmOffsets = @[@(-60), @(-300)];
    [ZZCalendarEventStore addEventWithTitle:@"订阅标题啊" startDate:startDate endDate:endDate location:nil notes:nil url:nil allDay:NO alarmOffsets:alarmOffsets recurrenceRules:nil completionHandler:^(BOOL success, NSString * __nullable eventIdentifier, BOOL granted, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!granted) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请在”设置-隐私-日历“选项中，允许App访问您的相机。" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *canelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertController addAction:canelAction];
                UIAlertAction *setAction = [UIAlertAction actionWithTitle:@"去设置" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    // 打开设置页面
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }];
                [alertController addAction:setAction];
                [self presentViewController:alertController animated:YES completion:nil];
                
                
            } else {
                NSString *title = success ? @"添加成功" : @"添加失败";
                NSString *message = success ? [NSString stringWithFormat:@"eventIdentifier = %@", eventIdentifier] : error.description;
                [self showAlertWithTitle:title message:message];
            }
        });
    }];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *canelAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:canelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
