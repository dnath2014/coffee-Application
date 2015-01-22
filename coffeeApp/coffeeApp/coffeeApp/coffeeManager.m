//
//  coffeeManager.m
//  coffeeApp
//
//  Created by Prasad on 10/28/14.
//  Copyright (c) 2014 Prasad. All rights reserved.
//

#import "coffeeManager.h"
#import "coffeeClient.h"
#import "coffeeItem.h"
#import "coffeeDetail.h"



@interface coffeeManager()

	@property (nonatomic,strong,readwrite) NSArray * coffeArray;
	@property (nonatomic, strong) coffeeClient *client;

@end

@implementation coffeeManager


+(instancetype) sharedManager{
	
	static id _sharedManager = nil;
	
	static dispatch_once_t  pred;
	
	dispatch_once(&pred, ^{
		_sharedManager=[[coffeeManager alloc] init]; //Create singleton
		
		
	});
	
	return _sharedManager;
}


-(id)init
{
	self= [super init];
	
	if(self)
	{
		_client=[[coffeeClient alloc] init];
		
		_detailImageDict=[[NSMutableDictionary alloc] init];
	}
	
	return self;
}


-(void) getCoffeItems:(void (^)(NSString * errorDetail))errorBlock     //Get the array of coffee items
{
	[[self.client getJASONforCoffeeTable] subscribeNext:^(NSArray *items) {
        self.coffeArray = items;
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:items] forKey:@"coffeelist"];
        [[NSUserDefaults standardUserDefaults] synchronize]; //Store it for using offline
        
	} error:^(NSError *error) {
        
        
        if(error.code==-1009){  //The device is offline get the stored data
            NSData * listofcoffee=[[NSUserDefaults standardUserDefaults] objectForKey:@"coffeelist"];
            if(listofcoffee != nil){
                NSArray *items=[NSKeyedUnarchiver unarchiveObjectWithData:listofcoffee];
                self.coffeArray =items;
                return;
            }
        }
        
		errorBlock([error localizedDescription]);
	}] ;
}


-(void) getCoffeeDetail:(NSString *)coffeeId completionBlock:(void (^)(coffeeDetail *detail))completionBlock errorBlock:(void (^)(NSString * errorDetail))errorBlock //Get the details of selected coffee
{
	
	
	[[self.client getJASONforCoffeeDetail:coffeeId] subscribeNext:^(coffeeDetail *detail) {
		self.coffeeDetail=detail;
		
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:detail] forKey:[NSString stringWithFormat:@"detailkey%@",coffeeId]];
        [[NSUserDefaults standardUserDefaults] synchronize]; //Store it for using offline
        
         dispatch_async( dispatch_get_main_queue(), ^{
		completionBlock(detail);
         });
	} error:^(NSError *error) {
        
        if(error.code==-1009){ //The device is offline get the stored data
            NSData * detofcoffee=[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"detailkey%@",coffeeId]];
            if(detofcoffee != nil){
                coffeeDetail *detail=[NSKeyedUnarchiver unarchiveObjectWithData:detofcoffee];
                
                self.coffeeDetail=detail;
				
                dispatch_async( dispatch_get_main_queue(), ^{
                    completionBlock(detail);
                });
                return;
            }
        }

        
		errorBlock([error localizedDescription]);
	}];
}

-(void) addtoPersistenceStore:(UIImage *)image coffeID:(NSString *)coffeeId //Store for offline use
{
	[self.detailImageDict setObject:image forKey:coffeeId];
	[[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.detailImageDict] forKey:@"imagedictionary"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}




-(void)downloadImagewitthUrlString:(NSString *)URLString completionBlock:(void (^)(UIImage *image,BOOL succeeded))completionBlock
{
	
	[self.client downloadImagewitthUrlSring:URLString completionBlock: ^(UIImage *image,BOOL succeeded) {
		[self addtoPersistenceStore:image coffeID:URLString];
		
		dispatch_async( dispatch_get_main_queue(), ^{
			completionBlock(image,succeeded);
		});
		
    } errorBlock:^(NSError *error){
        if(error.code==-1009){         //The device is offline get the stored data
            NSData * coffeeImage=[[NSUserDefaults standardUserDefaults] objectForKey:@"imagedictionary"];
            if(coffeeImage != nil){
                NSDictionary *coffeeImageDict=[NSKeyedUnarchiver unarchiveObjectWithData:coffeeImage];
                UIImage *image=[coffeeImageDict objectForKey:URLString];
               
                dispatch_async( dispatch_get_main_queue(), ^{
                    completionBlock(image,YES);
                });
                return;
            }
        }
        
        completionBlock(nil,NO);

        
    }];
}



@end
