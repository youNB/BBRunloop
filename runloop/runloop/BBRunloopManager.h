//
//  BBRunloopManager.h
//  runloop
//
//  Created by 程肖斌 on 2019/1/21.
//  Copyright © 2019年 ICE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBRunloopManager : NSObject

//单例
+ (BBRunloopManager *)sharedManager;

/*
    添加回调；
    但凡是必须放在主线程，又会阻塞主线程的操作都可以放在这里
*/
- (void)addHandle:(void (^)(void))handle;

@end

