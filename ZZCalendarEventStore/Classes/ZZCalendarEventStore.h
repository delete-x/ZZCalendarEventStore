//
//  ZZCalendarEventStore.h
//  ZZCalendarEventStore
//
//  Created by 任强宾 on 2020/12/2.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

typedef void(^ZZCalendarEventStoreCompletionHandler)(BOOL success, NSString * __nullable eventIdentifier, BOOL granted, NSError * __nullable error);

@interface ZZCalendarEventStore : NSObject

/// 添加一个日历事件
/// @param title 标题
/// @param startDate 事件开始时间
/// @param endDate 事件结束时间
/// @param location 地理位置(也可以与地理无关，充当副标题)
/// @param notes 备注
/// @param url 跳转链接
/// @param allDay 是否是全天
/// @param alarmOffsets 相对开始时间提醒的相对时间差（负值为提前提醒，正值为开始后提醒）
/// @param recurrenceRules 循环规则
/// @param completionHandler 异步操作结束回调
+ (void)addEventWithTitle:(NSString * _Nonnull)title startDate:(NSDate * _Nonnull)startDate endDate:(NSDate * _Nonnull)endDate location:(NSString * _Nullable)location notes:(NSString * _Nullable)notes url:(NSString * _Nullable)url allDay:(BOOL)allDay alarmOffsets:(NSArray<NSNumber *> * _Nullable)alarmOffsets recurrenceRules:(NSArray<EKRecurrenceRule *> * _Nullable)recurrenceRules completionHandler:(ZZCalendarEventStoreCompletionHandler _Nullable)completionHandler;

@end

