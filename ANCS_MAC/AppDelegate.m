//
//  AppDelegate.m
//  ANCS_MAC
//
//  Created by lizhao on 2017/3/23.
//  Copyright © 2017年 lizhao. All rights reserved.
//

#import "AppDelegate.h"
#import "ANCSServiceType.h"

@interface AppDelegate ()

@property(nonatomic, strong) CBCentralManager *manager;
@property(nonatomic, strong) CBPeripheral *np;

@property(nonatomic, strong) CBCharacteristic *ds;
@property(nonatomic, strong) CBCharacteristic *cp;
@property(nonatomic, strong) CBCharacteristic *ns;

@property(nonatomic, strong) NSMutableArray *dsDataCache;
@property(nonatomic, strong) CBCharacteristic *controlChar;
@property(nonatomic, strong) NSTimer *delayTimer;


@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    [NSUserNotificationCenter defaultUserNotificationCenter].delegate = self;
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    [self.manager cancelPeripheralConnection:self.np];
}

- (void)startScan {
    NSLog(@"Start Scan...");
    NSArray *services = @[
                          [CBUUID UUIDWithString:ANCS_SERVICE],
                          [CBUUID UUIDWithString:NOTIFICATION_SOURCE],
                          [CBUUID UUIDWithString:CONTROL_POINT],
                          [CBUUID UUIDWithString:DATA_SOURCE]
                          ];
    NSDictionary *options = @{
                        CBCentralManagerScanOptionAllowDuplicatesKey:[NSNumber numberWithBool:YES]
                        };
    
    [self.manager scanForPeripheralsWithServices:services options:options];
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    NSLog(@"%@,%@",NSStringFromSelector(_cmd), central);
    if (central.state == CBCentralManagerStatePoweredOn) {
        [self startScan];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@"%@,Advert:%@",NSStringFromSelector(_cmd), advertisementData);
    self.np = peripheral;
    [central connectPeripheral:peripheral options:nil];
    [central stopScan];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"%@,%@",NSStringFromSelector(_cmd), central);
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    NSLog(@"%@,Error:%@",NSStringFromSelector(_cmd), error.description);
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    NSLog(@"%@,%@",NSStringFromSelector(_cmd), central);
}



@end
