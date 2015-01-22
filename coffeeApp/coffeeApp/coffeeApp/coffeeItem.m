//
//  coffeeItem.m
//  coffeeApp
//
//  Created by Prasad on 10/28/14.
//  Copyright (c) 2014 Prasad. All rights reserved.
//

#import "coffeeItem.h"

/* Each coffee item of the created from JASON response */

@implementation coffeeItem


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"coffeeDesc": @"desc",
             @"coffeeName": @"name",
             @"coffeeId": @"id",
             @"coffeeImageUrl": @"image_url",
             
             };
}




@end
