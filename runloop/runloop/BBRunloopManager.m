//
//  BBRunloopManager.m
//  runloop
//
//  Created by 程肖斌 on 2019/1/21.
//  Copyright © 2019年 ICE. All rights reserved.
//

#import "BBRunloopManager.h"

@interface BBRunloopManager ()
@property(nonatomic, strong) NSMutableArray *callbacks;
@end

@implementation BBRunloopManager

//单例
+ (BBRunloopManager *)sharedManager{
    static BBRunloopManager *manager = nil;
    static dispatch_once_t   once_t  = 0;
    dispatch_once(&once_t, ^{
        manager = [[self alloc]init];
        //由于是单例，不会被销毁，所以timer持有住manager，不需要进行invalidate
        [NSTimer scheduledTimerWithTimeInterval:0.1
                                         target:manager
                                       selector:@selector(timeCount)
                                       userInfo:nil repeats:YES];
    });
    return manager;
}

- (void)timeCount{}

- (instancetype)init{
    if([super init]){
        CFRunLoopRef ref = CFRunLoopGetCurrent();
        CFRunLoopObserverContext ctx = {
            0,
            (__bridge void *)self,
            &CFRetain,
            &CFRelease,
            NULL
        };
        
        CFRunLoopObserverRef observer = CFRunLoopObserverCreate(NULL, kCFRunLoopBeforeWaiting, YES, 0, &callback, &ctx);
        CFRunLoopAddObserver(ref, observer, kCFRunLoopCommonModes);
        
        CFRelease(observer);
    }
    return self;
}

void callback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    BBRunloopManager *manager = (__bridge BBRunloopManager *)info;
    if(!manager.callbacks.count){return;}
    void(^callback)(void) = manager.callbacks.firstObject;
    callback();
    [manager.callbacks removeObjectAtIndex:0];
}

//添加新的回调
- (void)addHandle:(void (^)(void))handle{
    [self.callbacks addObject:handle];
}

@end
