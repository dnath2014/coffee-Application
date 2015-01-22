//
//  coffeeDetail.m
//  coffeeApp
//
//  Created by Prasad on 10/29/14.
//  Copyright (c) 2014 Prasad. All rights reserved.
//

/* Details of coffee created from JASON Response */

#import "coffeeDetail.h"

@implementation coffeeDetail


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"coffeeDesc": @"desc",
             @"coffeeName": @"name",
             @"coffeeId": @"id",
             @"coffeeImageUrl": @"image_url",
			 @"lastUpdated":@"last_updated_at"
             
             };
}


@end
