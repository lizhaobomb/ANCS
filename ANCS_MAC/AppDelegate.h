//
//  AppDelegate.h
//  ANCS_MAC
//
//  Created by lizhao on 2017/3/23.
//  Copyright © 2017年 lizhao. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, CBCentralManagerDelegate, CBPeripheralDelegate,NSUserNotificationCenterDelegate>


@end

