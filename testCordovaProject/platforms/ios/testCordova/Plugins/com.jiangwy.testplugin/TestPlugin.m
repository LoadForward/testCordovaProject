//
//  TestPlugin.m
//  testCordova
//
//  Created by 江威严 on 2019/3/28.
//

#import "TestPlugin.h"

@implementation TestPlugin

- (void)testWithTitle:(CDVInvokedUrlCommand *)command {
    if (command.arguments.count > 0) {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:SWIFT_CDVCommandStatus_OK messageAsString:@"OC回传的参数"];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    } else {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:SWIFT_CDVCommandStatus_ERROR messageAsString:@"没有参数"];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }
}

@end
