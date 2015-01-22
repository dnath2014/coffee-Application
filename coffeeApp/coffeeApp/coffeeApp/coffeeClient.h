//
//  coffeeClient.h
//  coffeeApp
//
//  Created by Prasad on 10/28/14.
//  Copyright (c) 2014 Prasad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>
#import <AFNetworking/AFNetworking.h>
#import <Mantle.h>


@interface coffeeClient : NSObject


-(RACSignal *)getJASONforCoffeeTable;
-(RACSignal *)getJASONforCoffeeDetail:(NSString *)coffeeId;
-(void)downloadImagewitthUrlSring:(NSString *)URLString completionBlock:(void (^)(UIImage *image,BOOL succeeded))completionBlock errorBlock:(void (^)(NSError* error))errorBlock;

@end
