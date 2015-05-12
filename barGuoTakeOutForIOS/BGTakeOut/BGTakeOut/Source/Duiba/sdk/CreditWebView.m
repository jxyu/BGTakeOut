//
//  CreditWebView.m
//  dui88-iOS-sdk
//
//  Created by xuhengfei on 14-6-13.
//  Copyright (c) 2014年 cpp. All rights reserved.
//

#import "CreditWebView.h"


@interface CreditWebView()
@property (nonatomic,strong) NSString *url;
@end

@implementation CreditWebView

-(id)init{
    self=[super init];
    self.delegate=self;
    return self;
}
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    self.delegate=self;
    self.scalesPageToFit=YES;
    return self;
}
-(id)initWithFrame:(CGRect)frame andUrl:(NSString *)url{
    self=[self initWithFrame:frame];
    self.url=url;
    return self;
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSMutableString *url=[[NSMutableString alloc]initWithString:[request.URL absoluteString]];
    if([url rangeOfString:@"autoLogin/autologin" options:NSCaseInsensitiveSearch].location!=NSNotFound){
        NSDictionary *dict=[NSDictionary dictionaryWithObject:self forKey:@"webView"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"duiba-autologin-visit" object:nil userInfo:dict];
    }
        NSArray *urlComps = [url componentsSeparatedByString:@"://"];
        if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"objc"]){
            if([[urlComps objectAtIndex:1] hasPrefix:@"duiba/"]){
                NSArray *d=[[urlComps objectAtIndex:1] componentsSeparatedByString:@"/"];
                if(d.count==2 && [d[1] isEqualToString:@"login"]){
                    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
                    [dict setObject:webView.request.URL.absoluteString forKey:@"currentUrl"];
                    [dict setObject:webView forKey:@"webView"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"duiba-login-click" object:self userInfo:dict];
                    return NO;
                }
            }
        }
    
        if([url rangeOfString:@"dbnewopen"].location!=NSNotFound){
            [url replaceCharactersInRange:[url rangeOfString:@"dbnewopen"] withString:@"none"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"dbnewopen" object:nil userInfo:[NSDictionary dictionaryWithObject:url forKey:@"url"]];
            return NO;
        }else if([url rangeOfString:@"dbbackrefresh"].location!=NSNotFound){
            [url replaceCharactersInRange:[url rangeOfString:@"dbbackrefresh"] withString:@"none"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"dbbackrefresh" object:nil userInfo:[NSDictionary dictionaryWithObject:url  forKey:@"url"]];
            return  NO;
        
        }else if([url rangeOfString:@"dbbackrootrefresh"].location!=NSNotFound){
            [url replaceCharactersInRange:[url rangeOfString:@"dbbackrootrefresh"] withString:@"none"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"dbbackrootrefresh" object:nil userInfo:[NSDictionary dictionaryWithObject:url forKey:@"url"]];
            return NO;
        }else if([url rangeOfString:@"dbbackroot"].location!=NSNotFound){
            [url replaceCharactersInRange:[url rangeOfString:@"dbbackroot"] withString:@"none"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"dbbackroot" object:nil userInfo:[NSDictionary dictionaryWithObject:url forKey:@"url"]];
            return NO;
        }else if([url rangeOfString:@"dbback"].location!=NSNotFound){
            [url replaceCharactersInRange:[url rangeOfString:@"dbback"] withString:@"none"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"dbback" object:nil userInfo:[NSDictionary dictionaryWithObject:url forKey:@"url"]];
            return NO;
            
            
        }
    
    return YES;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if(self.webDelegate !=nil && [self.webDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]){
        [self.webDelegate webView:webView didFailLoadWithError:error];
    }
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    if(self.webDelegate !=nil && [self.webDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]){
        [self.webDelegate webViewDidFinishLoad:webView];
    }
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    if(self.webDelegate !=nil && [self.webDelegate respondsToSelector:@selector(webViewDidStartLoad:)]){
        [self.webDelegate webViewDidStartLoad:webView];
    }
}


@end
