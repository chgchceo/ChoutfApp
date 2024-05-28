//
//  UIWebView+IgnoreSSL.h
//  ZDFProduct
//
//  Created by yuanbing bei on 2023/9/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLRequest (IgnoreSSL)



+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;


@end

NS_ASSUME_NONNULL_END
