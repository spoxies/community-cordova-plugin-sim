// MCC and MNC codes on Wikipedia
// http://en.wikipedia.org/wiki/Mobile_country_code

// Mobile Network Codes (MNC) for the international identification plan for public networks and subscriptions
// http://www.itu.int/pub/T-SP-E.212B-2014

// class CTCarrier
// https://developer.apple.com/reference/coretelephony/ctcarrier?language=objc

#import "Sim.h"
#import <Cordova/CDV.h>
#import <Foundation/Foundation.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation Sim

- (void)getSimInfo:(CDVInvokedUrlCommand*)command
{
 
    BOOL allowsVOIPResult = false;
    
    NSString *carrierNameResult = @"";
    NSString *carrierCodeResult = @"";
    NSString *carrierNetworkResult = @"";
    NSString *carrierCountryResult = @"";;
    
    if (@available(iOS 16.3, *)) {
        carrierNameResult = @"Deprecated API";

        NSLocale *countryLocale = [NSLocale currentLocale];
        carrierCountryResult = [countryLocale objectForKey:NSLocaleCountryCode];

        
        
    }else{
        
        NSDictionary<NSString *, CTCarrier *> *providers= [[CTTelephonyNetworkInfo new]  serviceSubscriberCellularProviders];
           
        CTCarrier *carrier = providers.allValues.firstObject;

        allowsVOIPResult = [carrier allowsVOIP];
        carrierNameResult = [carrier carrierName];
        carrierCountryResult = [carrier isoCountryCode];
        carrierCodeResult = [carrier mobileCountryCode];
        carrierNetworkResult = [carrier mobileNetworkCode];

        if (!carrierNameResult) {
          carrierNameResult = @"";
        }
        if (!carrierCountryResult) {
          carrierCountryResult = @"";
        }
        if (!carrierCodeResult) {
          carrierCodeResult = @"";
        }
        if (!carrierNetworkResult) {
          carrierNetworkResult = @"";
        }
    }
    

    
    NSDictionary *simData = [NSDictionary dictionaryWithObjectsAndKeys:
      @(allowsVOIPResult), @"allowsVOIP",
      carrierNameResult, @"carrierName",
      carrierCountryResult, @"countryCode",
      carrierCodeResult, @"mcc",
      carrierNetworkResult, @"mnc",
      nil];
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:simData];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

@end
