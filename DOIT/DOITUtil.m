//
//  DOITUtil.m
//  DOIT
//
//  Created by AppDev on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "DOITUtil.h"
#import "GTMBase64.h"
#import "IPAddress.h"

@implementation DOITUtil

//此app的基本url
+(NSString*) getUrlBase{
    return @"http://m.doit.com.cn/api/";
    //return @"http://192.168.1.123:7001/doit2mobile/api/";
}

//获取请求的数据
+(NSString*) getRequestJsonData:(NSURL*)requestUrl{
    NSURL* url = [requestUrl retain];
    NSString* jsonData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    [url release];
    return jsonData;
}

//图片编码成base64字符串
+(NSString*) encodeBase64:(UIImage*)image{
    if (image) {
        NSData* data = UIImageJPEGRepresentation(image, 1.0);
        NSData* encodeData = [GTMBase64 encodeData:data];
        NSString* base64String = [[[NSString alloc] initWithData:encodeData encoding:NSUTF8StringEncoding] autorelease];
        return base64String;
    }else{
        return nil;
    }
}

+(NSString*) encodeStrBase64:(NSString*)String{
    if (String) {
        NSData* data = [String dataUsingEncoding:NSUTF8StringEncoding];
        NSData* encodeData = [GTMBase64 encodeData:data];
        NSString* base64String = [[[NSString alloc] initWithData:encodeData encoding:NSUTF8StringEncoding] autorelease];
        return base64String;
    }
    return nil;
}

//获取手机ip地址
+(NSString*)deviceIPAddress{
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    return [NSString stringWithFormat:@"%s",ip_names[1]];
}

//获取手机mac地址
+(NSString*)deviceMACAddress{
    InitAddresses();
    GetIPAddresses();
    GetHWAddresses();
    
    int i;
    NSString *deviceIP = nil;
    for (i=0; i<MAXADDRS; ++i)
    {
//        static unsigned long localHost = 0x7F000001;            // 127.0.0.1
//        unsigned long theAddr;
//        
//        theAddr = ip_addrs[i];
//        
//        if (theAddr == 0) break;
//        if (theAddr == localHost) continue;
//        
//        NSLog(@"Name: %s MAC: %s IP: %s\n", if_names[i], hw_addrs[i], ip_names[i]);
        
        deviceIP = [NSString stringWithFormat:@"%s",hw_addrs[i]];
        
//        //decided what adapter you want details for
//        if (strncmp(if_names[i], "en", 2) == 0)
//        {
//            NSLog(@"Adapter en has a IP of %@", [NSString stringWithFormat:@"%s", ip_names[i]]);
//        }
    }
    return deviceIP;
}

//获取设备ID
+(NSString*) deviceID{
    UIDevice* deviceid = [UIDevice currentDevice];
    NSString* deviceUID = [[[NSString alloc] initWithString:[deviceid uniqueIdentifier]] autorelease];
    return deviceUID;
}

@end
