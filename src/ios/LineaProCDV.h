//
//  LineaProCDV.h
//
//  Created by Timofey Tatarinov on 27.01.14.
//  Citronium
//  http://citronium.com
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <Cordova/CDVPlugin.h>

#import "DTDevices.h"

@interface LineaProCDV : CDVPlugin
{
    DTDevices *dtdev;
}

- (void)initDT:(CDVInvokedUrlCommand*)command;
- (void)getConnectionStatus:(CDVInvokedUrlCommand*)command;
- (void)startBarcode:(CDVInvokedUrlCommand*)command;
- (void)stopBarcode:(CDVInvokedUrlCommand*)command;

- (void)getAutoOffWhenIdle:(CDVInvokedUrlCommand*)command;
- (void)getBatteryCapacity:(CDVInvokedUrlCommand*)command;
- (void)getBatteryInfo:(CDVInvokedUrlCommand*)command;
- (void)getConnectedDeviceBatteryInfo:(CDVInvokedUrlCommand*)command;
- (void)getConnectedDeviceInfo:(CDVInvokedUrlCommand*)command;
- (void)getKioskMode:(CDVInvokedUrlCommand*)command;
- (void)getCharging:(CDVInvokedUrlCommand*)command;
- (void)getPassThroughSync:(CDVInvokedUrlCommand*)command;
- (void)getUSBChargeCurrent:(CDVInvokedUrlCommand*)command;
- (void)getSupportedFeature:(CDVInvokedUrlCommand*)command;
- (void)getTimeRemainingToPowerOff:(CDVInvokedUrlCommand*)command;

@end
