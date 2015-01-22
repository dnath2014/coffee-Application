//
//  coffeeItem.h
//  coffeeApp
//
//  Created by Prasad on 10/28/14.
//  Copyright (c) 2014 Prasad. All rights reserved.
//

#import <Mantle.h>

@interface coffeeItem : MTLModel<MTLJSONSerializing>


@property (nonatomic,strong) NSString * coffeeDesc;

@property (nonatomic,strong) NSString * coffeeName;
@property (nonatomic,strong) NSString * coffeeId;
@property (nonatomic,strong) NSString * coffeeImageUrl;

@end
