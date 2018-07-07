//
//  LineaProCDV.m
//
//  Created by Timofey Tatarinov on 27.01.14.
//  Citronium
//  http://citronium.com
//

#import "LineaProCDV.h"

@interface LineaProCDV()

+ (NSString*) getPDF417ValueByCode: (NSArray*) codesArr code:(NSString*)code;

@end

@implementation LineaProCDV

-(void) scannerConect:(NSString*)num {

    NSString *jsStatement = [NSString stringWithFormat:@"reportConnectionStatus('%@');", num];
    if ([self.webView isKindOfClass:[UIWebView class]]) {
        [(UIWebView*)self.webView stringByEvaluatingJavaScriptFromString:jsStatement];
    } else if([self.webView isKindOfClass:[WKWebView class]]) {
        [(WKWebView*)self.webView evaluateJavaScript:jsStatement completionHandler:nil];
    }

}

-(void) scannerBattery:(NSString*)num {

    int percent;
    float voltage;

	if([dtdev getBatteryCapacity:&percent voltage:&voltage error:nil])
    {
        NSString *status = [NSString stringWithFormat:@"Bat: %.2fv, %d%%",voltage,percent];

        // send to web view
        NSString *jsStatement = [NSString stringWithFormat:@"reportBatteryStatus('%@');", status];
        if ([self.webView isKindOfClass:[UIWebView class]]) {
            [(UIWebView*)self.webView stringByEvaluatingJavaScriptFromString:jsStatement];
        } else if([self.webView isKindOfClass:[WKWebView class]]) {
            [(WKWebView*)self.webView evaluateJavaScript:jsStatement completionHandler:nil];
        }

    }
}




-(void) getAutoOffWhenIdle:(CDVInvokedUrlCommand*)command
{
    double interval;
    double whenDisconnected;
    [dtdev getAutoOffWhenIdle:&interval whenDisconnected:&whenDisconnected error:nil];
    NSLog(@"getAutoOffWhenIdle: %@, %f, %f", command.callbackId, interval, whenDisconnected);
    NSString* retStr = [NSString stringWithFormat:@"{\"interval\": %f, \"whenDisconnected\": %f}", interval, whenDisconnected];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:retStr];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void) getBatteryCapacity:(CDVInvokedUrlCommand*)command
{
    int percent;
    float voltage;

    [dtdev getBatteryCapacity:&percent voltage:&voltage error:nil];
    NSLog(@"getBatteryCapacity: %@, %d, %f", command.callbackId, percent, voltage);
    NSString* retStr = [NSString stringWithFormat:@"{\"percent\": %d, \"voltage\": %f}", percent, voltage];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:retStr];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void) getBatteryInfo:(CDVInvokedUrlCommand*)command
{
    DTBatteryInfo* data = [dtdev getBatteryInfo:nil];
    NSLog(@"getBatteryInfo: %@, %@", command.callbackId, data);
    NSString* retStr = [NSString stringWithFormat:@"{\"batteryInfo\": \"%@\"}", data];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:retStr];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void) getConnectedDeviceBatteryInfo:(CDVInvokedUrlCommand*)command
{
    NSLog(@"getConnectedDeviceBatteryInfo: %@", command);
}

-(void) getConnectedDeviceInfo:(CDVInvokedUrlCommand*)command
{
    NSLog(@"getConnectedDeviceInfo: %@", command);
}

-(void) getKioskMode:(CDVInvokedUrlCommand*)command
{
    NSLog(@"getKioskMode: %@", command);
}

-(void) getCharging:(CDVInvokedUrlCommand*)command
{
    bool isCharging = false;
    [dtdev getCharging:&isCharging error:nil];
    NSLog(@"getCharging: %@, %d", command.callbackId, (int)isCharging);
    NSString* retStr = [NSString stringWithFormat:@"{\"isChargingEnabled\": \"%d\"}", (int)isCharging];

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:retStr];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
-(void) setCharging:(bool)isCharging
{
    [dtdev setCharging:isCharging error:nil];
}

-(void) getPassThroughSync:(CDVInvokedUrlCommand*)command
{
    NSLog(@"getPassThroughSync: %@", command);
}

-(void) getUSBChargeCurrent:(CDVInvokedUrlCommand*)command
{
    NSLog(@"getUSBChargeCurrent: %@", command);
}

-(void) getSupportedFeature:(CDVInvokedUrlCommand*)command
{
    NSLog(@"getSupportedFeature: %@", command);
}

-(void) getTimeRemainingToPowerOff:(CDVInvokedUrlCommand*)command
{
    NSLog(@"getTimeRemainingToPowerOff: %@", command);
}




-(void) scanPaymentCard:(NSString*)num {

    NSString *jsStatement = [NSString stringWithFormat:@"onSuccessScanPaymentCard('%@');", num];
    if ([self.webView isKindOfClass:[UIWebView class]]) {
        [(UIWebView*)self.webView stringByEvaluatingJavaScriptFromString:jsStatement];
    } else if([self.webView isKindOfClass:[WKWebView class]]) {
        [(WKWebView*)self.webView evaluateJavaScript:jsStatement completionHandler:nil];
    }
	[self.viewController dismissViewControllerAnimated:YES completion:nil];

}

- (void)initDT:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;

    if (!dtdev) {
        dtdev = [DTDevices sharedDevice];
        [dtdev addDelegate:self];
        [dtdev connect];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getConnectionStatus:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:[dtdev connstate]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)startBarcode:(CDVInvokedUrlCommand *)command
{
    [dtdev barcodeStartScan:nil];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:[dtdev connstate]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)stopBarcode:(CDVInvokedUrlCommand *)command
{
    [dtdev barcodeStopScan:nil];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:[dtdev connstate]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)connectionState: (int)state {
    NSLog(@"connectionState: %d", state);

    switch (state) {
		case CONN_DISCONNECTED:
		case CONN_CONNECTING:
                break;
		case CONN_CONNECTED:
		{
			NSLog(@"PPad connected!\nSDK version: %d.%d\nHardware revision: %@\nFirmware revision: %@\nSerial number: %@", dtdev.sdkVersion/100,dtdev.sdkVersion%100,dtdev.hardwareRevision,dtdev.firmwareRevision,dtdev.serialNumber);
			break;
		}
	}

    NSString* retStr = [ NSString stringWithFormat:@"LineaProCDV.connectionChanged(%d);", state];
    if ([self.webView isKindOfClass:[UIWebView class]]) {
        [(UIWebView*)self.webView stringByEvaluatingJavaScriptFromString:retStr];
    } else if([self.webView isKindOfClass:[WKWebView class]]) {
        [(WKWebView*)self.webView evaluateJavaScript:retStr completionHandler:nil];
    }
}

- (void) deviceButtonPressed: (int) which {
    NSLog(@"deviceButtonPressed: %d", which);
}

- (void) deviceButtonReleased: (int) which {
    NSLog(@"deviceButtonReleased: %d", which);
}

- (void) deviceFeatureSupported: (int) feature value:(int) value {
    NSLog(@"deviceFeatureSupported: feature - %d, value - %d", feature, value);
}

- (void) firmwareUpdateProgress: (int) phase percent:(int) percent {
    NSLog(@"firmwareUpdateProgress: phase - %d, percent - %d", phase, percent);
}

- (void) magneticCardData: (NSString *) track1 track2:(NSString *) track2 track3:(NSString *) track3 {
    NSDictionary *card = [dtdev msProcessFinancialCard:track1 track2:track2];

    if(card && [card objectForKey:@"accountNumber"]!=nil && [[card objectForKey:@"expirationYear"] intValue]!=0)
    {
        int sound[]={2730,150,0,30,2730,150};
        [dtdev playSound:100 beepData:sound length:sizeof(sound) error:nil];

        NSError * err;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:card options:0 error:&err];
        NSString * string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString* retStr = [NSString stringWithFormat:@"LineaProCDV.onMagneticCardData('%@')",string];

        NSLog(@"magneticCardData: %@", retStr);

        if ([self.webView isKindOfClass:[UIWebView class]]) {
            [(UIWebView*)self.webView stringByEvaluatingJavaScriptFromString:retStr];
        } else if([self.webView isKindOfClass:[WKWebView class]]) {
            [(WKWebView*)self.webView evaluateJavaScript:retStr completionHandler:nil];
        }
    }
}

- (void) magneticCardEncryptedData: (int) encryption tracks:(int) tracks data:(NSData *) data {
    NSLog(@"magneticCardEncryptedData: encryption - %d, tracks - %d, data - %@", encryption, tracks, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

- (void) magneticCardEncryptedData: (int) encryption tracks:(int) tracks data:(NSData *) data track1masked:(NSString *) track1masked track2masked:(NSString *) track2masked track3:(NSString *) track3 {
    NSLog(@"magneticCardEncryptedData: encryption - %d, tracks - %d, track3 - %@, track1masked - %@, track2masked - %@, track3 - %@", encryption, tracks, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], track1masked, track2masked, track3);
}

- (void) magneticCardEncryptedRawData: (int) encryption data:(NSData *) data {
    NSLog(@"magneticCardEncryptedRawData: encryption - %d, data - %@", encryption, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

- (void) magneticCardRawData: (NSData *) tracks {
    NSLog(@"magneticCardRawData: data - %@", [[NSString alloc] initWithData:tracks encoding:NSUTF8StringEncoding]);
}

- (void) magneticJISCardData: (NSString *) data {
    NSLog(@"magneticJISCardData: data - %@", data);
}

- (void) paperStatus: (BOOL) present {
    NSLog(@"paperStatus: present - %d", present);
}

- (void) PINEntryCompleteWithError: (NSError *) error {
    NSLog(@"PINEntryCompleteWithError: error - %@", [error localizedDescription]);
}

- (void) rfCardDetected: (int) cardIndex info:(DTRFCardInfo *) info {
    NSLog(@"rfCardDetected (debug): cardIndex - %d, info - %@", cardIndex, [info description]);
    NSLog(@"rfCardDetected (debug): cardIndex - %d, info - %@", cardIndex, [info debugDescription]);
}

- (void) rfCardRemoved: (int) cardIndex {
    NSLog(@"rfCardRemoved: cardIndex - %d", cardIndex);
}

- (void) sdkDebug: (NSString *) logText source:(int) source {
    NSLog(@"sdkDebug: logText - %@, source - %d", logText, source);
}

- (void) smartCardInserted: (SC_SLOTS) slot {
    NSLog(@"smartCardInserted: slot - %d", slot);
}

- (void) smartCardRemoved: (SC_SLOTS) slot {
    NSLog(@"smartCardRemoved: slot - %d", slot);
}

- (void) barcodeData: (NSString *) barcode type:(int) type {
    NSString* retStr = [ NSString stringWithFormat:@"LineaProCDV.onBarcodeData('{\"barcode\": \"%@\", \"type\": \"%@\"}');", barcode, [dtdev barcodeType2Text:type]];

    NSLog(@"barcodeData: %@", retStr);
    if ([self.webView isKindOfClass:[UIWebView class]]) {
        [(UIWebView*)self.webView stringByEvaluatingJavaScriptFromString:retStr];
    } else if([self.webView isKindOfClass:[WKWebView class]]) {
        [(WKWebView*)self.webView evaluateJavaScript:retStr completionHandler:nil];
    }
}

- (void) barcodeNSData: (NSData *) barcode isotype:(NSString *) isotype {
    NSString* retStr = [ NSString stringWithFormat:@"LineaProCDV.onBarcodeData('{\"barcode\": \"%@\", \"type\": \"%@\"}');", [[NSString alloc] initWithData:barcode encoding:NSUTF8StringEncoding], isotype];

    NSLog(@"barcodeNSData: %@", retStr);
    if ([self.webView isKindOfClass:[UIWebView class]]) {
        [(UIWebView*)self.webView stringByEvaluatingJavaScriptFromString:retStr];
    } else if([self.webView isKindOfClass:[WKWebView class]]) {
        [(WKWebView*)self.webView evaluateJavaScript:retStr completionHandler:nil];
    }
}

+ (NSString*) getPDF417ValueByCode: (NSArray*) codesArr code:(NSString*)code {
    for (NSString* currStr in codesArr) {
        // do something with object
        NSRange range = [currStr rangeOfString:code];
        if (range.length == 0) continue;
        NSString *substring = [[currStr substringFromIndex:NSMaxRange(range)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        return substring;
    }
    return NULL;
}

+ (NSString*) generateStringForArrayEvaluationInJS: (NSArray*) stringsArray {
    NSString* arrayJSString = [NSString stringWithFormat:@"["];
    BOOL isFirst = TRUE;
    for (int i = 0; i < stringsArray.count; ++i) {
        NSString* currString = [stringsArray objectAtIndex:i];
        if (currString.length <= 1) continue;
        arrayJSString = [NSString stringWithFormat:@"%@%@\"%@\"", arrayJSString, isFirst ? @"" : @",", currString];
        isFirst = FALSE;
    }
    arrayJSString = [NSString stringWithFormat:@"%@]", arrayJSString];
    return arrayJSString;
}

- (void) barcodeNSData: (NSData *) barcode type:(int) type {
    NSString* retStr = [ NSString stringWithFormat:@"LineaProCDV.onBarcodeData('{\"barcode\": \"%@\", \"type\": \"%@\"}');", [[NSString alloc] initWithData:barcode encoding:NSUTF8StringEncoding], [dtdev barcodeType2Text:type]];

    NSLog(@"barcodeNSData: %@", retStr);
    if ([self.webView isKindOfClass:[UIWebView class]]) {
        [(UIWebView*)self.webView stringByEvaluatingJavaScriptFromString:retStr];
    } else if([self.webView isKindOfClass:[WKWebView class]]) {
        [(WKWebView*)self.webView evaluateJavaScript:retStr completionHandler:nil];
    }
}

- (void) bluetoothDeviceConnected: (NSString *) address {
    NSLog(@"bluetoothDeviceConnected: address - %@", address);
}

- (void) bluetoothDeviceDisconnected: (NSString *) address {
    NSLog(@"bluetoothDeviceDisconnected: address - %@", address);
}

- (void) bluetoothDeviceDiscovered: (NSString *) address name:(NSString *) name {
    NSLog(@"bluetoothDeviceDiscovered: address - %@, name - @name", name);
}
- (NSString *) bluetoothDevicePINCodeRequired: (NSString *) address name:(NSString *) name {
    NSLog(@"bluetoothDevicePINCodeRequired: address - %@, name - @name", name);
    return address;
}

- (BOOL) bluetoothDeviceRequestedConnection: (NSString *) address name:(NSString *) name {
    NSLog(@"bluetoothDeviceRequestedConnection: address - %@, name - @name", name);
    return TRUE;
}

- (void) bluetoothDiscoverComplete: (BOOL) success {
    NSLog(@"bluetoothDiscoverComplete: success - %d", success);
}



@end
