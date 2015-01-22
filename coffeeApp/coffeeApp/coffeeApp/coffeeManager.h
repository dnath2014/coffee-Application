//
//  coffeeManager.h
//  coffeeApp
//
//  Created by Prasad on 10/28/14.
//  Copyright (c) 2014 Prasad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "coffeeDetail.h"

@interface coffeeManager : NSObject


@property (nonatomic,strong,readonly) NSArray * coffeArray;  //Array of coffee to be used in table view
@property (nonatomic,strong) coffeeDetail * coffeeDetail;  //Detail of Coffee

@property (nonatomic,strong) NSMutableDictionary * detailImageDict; //Dictionary of images of coffee for storing in persistant store to be used in offline


+(instancetype) sharedManager;
-(void)downloadImagewitthUrlString:(NSString *)URLString completionBlock:(void (^)(UIImage *image,BOOL succeeded))completionBlock;

-(void) addtoPersistenceStore:(UIImage *)image coffeID:(NSString *)coffeeId;

-(void) getCoffeItems:(void (^)(NSString * errorDetail))errorBlock;
-(void) getCoffeeDetail:(NSString *)coffeeId completionBlock:(void (^)(coffeeDetail *detail))completionBlock errorBlock:(void (^)(NSString * errorDetail))errorBlock;

@end
