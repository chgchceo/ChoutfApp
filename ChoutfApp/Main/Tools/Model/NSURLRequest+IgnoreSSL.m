//
//  UIWebView+IgnoreSSL.m
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/9/12.
//

#import "NSURLRequest+IgnoreSSL.h"

@implementation NSURLRequest (IgnoreSSL)



+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host {
   
    return YES;
    
}
@end
