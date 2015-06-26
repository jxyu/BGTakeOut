//
//  HttpRequest.h
//  BuerShopping
//
//  Created by 于金祥 on 15/6/15.
//  Copyright (c) 2015年 zykj.BuerShopping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequest : NSObject

+(id)upload:(NSString *)url widthParams:(NSDictionary *)params;

@end

@interface FileDetail : NSObject
@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) NSData *data;
+(FileDetail *)fileWithName:(NSString *)name data:(NSData *)data;
@end
