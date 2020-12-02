//
//  ZZCalendarEventStore.m
//  ZZCalendarEventStore
//
//  Created by 任强宾 on 2020/12/2.
//

#import "ZZCalendarEventStore.h"

//@interface ZZCalendarEventStore ()
//
//@property (nonatomic, strong) EKEventStore *eventStore;
//
//@end

@implementation ZZCalendarEventStore

//static ZZCalendarEventStore *instance;
//
//+ (instancetype)shared {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[ZZCalendarEventStore alloc] init];
//    });
//    return instance;
//}

+ (void)addEventWithTitle:(NSString * _Nonnull)title startDate:(NSDate * _Nonnull)startDate endDate:(NSDate * _Nonnull)endDate location:(NSString * _Nullable)location notes:(NSString * _Nullable)notes url:(NSString * _Nullable)url allDay:(BOOL)allDay alarmOffsets:(NSArray<NSNumber *> * _Nullable)alarmOffsets recurrenceRules:(NSArray<EKRecurrenceRule *> * _Nullable)recurrenceRules completionHandler:(ZZCalendarEventStoreCompletionHandler _Nullable)completionHandler {
    
    EKEventStore *store = [[EKEventStore alloc] init];
    if ([store respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
            if (error) {
                if (completionHandler) {
                    completionHandler(NO, nil, granted, error);
                }
            } else {
                if (!granted) {
                    if (completionHandler) {
                        completionHandler(NO, nil, granted, [self notGrantedError]);
                    }
                    return;
                }
                EKEvent *event = [EKEvent eventWithEventStore:store];
                event.title = title;
                event.startDate = startDate;
                event.endDate = endDate;
                event.location = location;
                event.notes = notes;
                if ([url isKindOfClass:[NSString class]] && url.length > 0) {
                    event.URL = [NSURL URLWithString:url];
                }
                event.allDay = allDay;
                // 添加提醒
                if (alarmOffsets && alarmOffsets.count > 0) {
                    for (NSNumber *alarmOffsetSec in alarmOffsets) {
                        if ([alarmOffsetSec isKindOfClass:[NSNumber class]]) {
                            [event addAlarm:[EKAlarm alarmWithRelativeOffset:[alarmOffsetSec integerValue]]];
                        }
                    }
                }
                // 添加循环规则
                if (recurrenceRules && recurrenceRules.count > 0) {
                    NSMutableArray *muRecurrenceRules = [NSMutableArray array];
                    for (EKRecurrenceRule *rule in recurrenceRules) {
                        if ([rule isKindOfClass:[EKRecurrenceRule class]]) {
                            [muRecurrenceRules addObject:rule];
                        }
                    }
                    if (muRecurrenceRules.count > 0) {
                        [event setRecurrenceRules:muRecurrenceRules];
                    }
                }
                [event setCalendar:[store defaultCalendarForNewEvents]];
                NSError *err;
                [store saveEvent:event span:EKSpanThisEvent error:&err];
                if (completionHandler) {
                    BOOL success = err ? NO : YES;
                    NSString *eventIdentifier = success ? event.eventIdentifier : nil;
                    if (success) {
                        completionHandler(success, eventIdentifier, granted, err);
                    }
                }
            }
        }];
    } else {
        if (completionHandler) {
            completionHandler(NO, nil, YES, [self notFoundMethodError]);
        }
    }
}

+ (NSError *)notFoundMethodError {
    NSError *error = [NSError errorWithDomain:@"not found method" code:404 userInfo:nil];
    return error;
}

+ (NSError *)notGrantedError {
    NSError *error = [NSError errorWithDomain:@"not granted" code:403 userInfo:nil];
    return error;
}

@end
