//
//  coffeeClient.m
//  coffeeApp
//
//  Created by Prasad on 10/28/14.
//  Copyright (c) 2014 Prasad. All rights reserved.
//



/* Handles http and JASON response*/


#import "coffeeClient.h"
#import "coffeeItem.h"
#import "coffeeDetail.h"


@implementation coffeeClient



-(RACSignal *)getJASONfromURL:(NSURL *)url
{
	
	return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
		AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
											 initWithRequest:request];
		operation.responseSerializer = [AFJSONResponseSerializer serializer];
		[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation
												   , id responseObject) {
			
			
			[subscriber sendNext:responseObject];
			
			
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			
			[subscriber sendError:error]; 
			
		}];
		
		[operation start];
		return [RACDisposable disposableWithBlock:^{
			[operation cancel];
            
        }];
		
	}]  doError:^(NSError *error) {
		
    }];
}




-(RACSignal *)getJASONforCoffeeTable            //Get the Jason Repsonse and create array of objects of class coffeeItem to be used in Table View
{
	NSString * urlString=@"http://coffeeapi.percolate.com/api/coffee/?api_key=WuVbkuUsCXHPx3hsQzus4SE";
	
	NSURL *coffeeUrl=[NSURL URLWithString:urlString];
	
	return [[self getJASONfromURL:coffeeUrl] map:^(NSArray *json) {
      
        return [MTLJSONAdapter modelsOfClass:[coffeeItem class] fromJSONArray:json error:nil];
     
    }];
	
}



-(RACSignal *)getJASONforCoffeeDetail:(NSString *)coffeeId //Get the Details of individual coffee item
{
	NSString * urlString=[NSString stringWithFormat:@"https://coffeeapi.percolate.com/api/coffee/%@/?api_key=WuVbkuUsCXHPx3hsQzus4SE",coffeeId];
	
	
	NSURL *coffeeUrl=[NSURL URLWithString:urlString];
	
	
	return [[self getJASONfromURL:coffeeUrl] map:^(NSDictionary *json) {
		return [MTLJSONAdapter modelOfClass:[coffeeDetail class] fromJSONDictionary:json error:nil];
    }];

}


-(void)downloadImagewitthUrlSring:(NSString *)URLString completionBlock:(void (^)(UIImage *image,BOOL succeeded)) completionBlock errorBlock:(void (^)(NSError* error))errorBlock //Download the image of the coffee
{
	
	NSURL *coffeeImageUrl=[NSURL URLWithString:URLString];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:coffeeImageUrl];
	AFHTTPRequestOperation* op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	op.responseSerializer = [AFImageResponseSerializer serializer];
	
	[op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation* operation, id responseObject){
		completionBlock(responseObject,YES);
		
	} failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        errorBlock(error);
		
	}];
	
	[op start];
}

@end
