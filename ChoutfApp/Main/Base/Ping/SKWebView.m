
//
//  SKWebView.m
//  haha
//
//  Created by housenkui on 2018/9/2.
//  Copyright © 2018年 com.meiniucn. All rights reserved.
//

#import "SKWebView.h"
#import "Utils.h"


@interface WKWebView ()<WKScriptMessageHandler>

@end
@implementation SKWebView

- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration {
    
    if(self = [super initWithFrame:frame configuration:configuration])
    {
        if (configuration.showConsole) {
            WKUserContentController *userCC = configuration.userContentController;
            [userCC addScriptMessageHandler:self name:@"log"];
            [userCC addScriptMessageHandler:self name:@"warn"];
            [userCC addScriptMessageHandler:self name:@"error"];
            [userCC addScriptMessageHandler:self name:@"info"];
            [self showConsole];
        }
        
    }
    return self;
}
//监听h5页面log，error等日志信息
- (void)showConsole {
    
    NSString *jsCodeLog = @"console.log = (function(oriLogFunc) {\
        return function() {\
            var args = Array.from(arguments);\
            var message;\
            try {\
                message = args.map(arg => {\
                    try {\
                        return JSON.stringify(arg);\
                    } catch (e) {\
                        return String(arg);\
                    }\
                }).join(', ');\
                window.webkit.messageHandlers.log.postMessage(message);\
            } catch (error) {\
                console.error('Failed to post log message:', error);\
            }\
            oriLogFunc.apply(console, args);\
        };\
    })(console.log);";
      
    [self.configuration.userContentController addUserScript:[[WKUserScript alloc] initWithSource:jsCodeLog injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES]];
    
    NSString *jsCodeWarn = @"console.warn = (function(oriWarnFunc) {\
        return function() {\
            var args = Array.from(arguments);\
            var message;\
            try {\
                message = args.map(arg => {\
                    try {\
                        return JSON.stringify(arg);\
                    } catch (e) {\
                        return String(arg);\
                    }\
                }).join(', ');\
                window.webkit.messageHandlers.warn.postMessage(message);\
            } catch (error) {\
                console.error('Failed to post warning message:', error);\
            }\
            oriWarnFunc.apply(console, args);\
        };\
    })(console.warn);";
      
    [self.configuration.userContentController addUserScript:[[WKUserScript alloc] initWithSource:jsCodeWarn injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES]];
    
    NSString *jsCodeError = @"console.error = (function(oriErrorFunc) {\
        return function() {\
            var args = Array.from(arguments);\
            var message;\
            try {\
                message = args.map(arg => {\
                    try {\
                        return JSON.stringify(arg);\
                    } catch (e) {\
                        return String(arg);\
                    }\
                }).join(', ');\
                window.webkit.messageHandlers.error.postMessage(message);\
            } catch (error) {\
                console.error('Failed to post error message:', error);\
            }\
            oriErrorFunc.apply(console, args);\
        };\
    })(console.error);";
      
    [self.configuration.userContentController addUserScript:[[WKUserScript alloc] initWithSource:jsCodeError injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES]];
    
    NSString *jsCodeInfo = @"console.info = (function(oriInfoFunc) {\
        function safeStringify(obj, indent = 2, cache = new WeakMap()) {\
            if (typeof obj !== 'object' || obj === null) {\
                return JSON.stringify(obj);\
            }\
            if (cache.has(obj)) {\
                return '[Circular]';\
            }\
            cache.set(obj, true);\
            let result = [];\
            if (Array.isArray(obj)) {\
                for (let i = 0; i < obj.length; i++) {\
                    result.push(safeStringify(obj[i], indent, cache));\
                }\
                return '[' + result.join(',\n' + ' '.repeat(indent)) + ']';\
            }\
            let keys = Object.keys(obj).sort();\
            for (let i = 0; i < keys.length; i++) {\
                let key = keys[i];\
                result.push(`${indent ? ' '.repeat(indent) : ''}${JSON.stringify(key)}: ${safeStringify(obj[key], indent + 2, cache)}`);\
            }\
            return '{\n' + result.join(',\n') + '\n}';\
        }\
        return function(...args) {\
            let message;\
            try {\
                message = args.map(arg => safeStringify(arg)).join(', ');\
                window.webkit.messageHandlers.info.postMessage(message);\
            } catch (error) {\
                console.error('Failed to post info message:', error);\
            }\
            oriInfoFunc.apply(console, args);\
        };\
    })(console.info);";
      
    [self.configuration.userContentController addUserScript:[[WKUserScript alloc] initWithSource:jsCodeInfo injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES]];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSString *name = message.name;
    NSString *date = [Utils getNowTimeStr];
    NSString *content = message.body;
    NSString *code = @"H5页面日志信息：";
    [Utils saveLogMessage:date withTitle:code withContent:content withCode:name];
    
}


@end
