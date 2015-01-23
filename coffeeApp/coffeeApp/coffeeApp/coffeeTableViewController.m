//
//  coffeeTableViewController.m
//  coffeeApp
//
//  Created by Prasad on 10/28/14.
//  Copyright (c) 2014 Prasad. All rights reserved.
//

#import "coffeeTableViewController.h"
#import "coffeeManager.h"
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>
#import "coffeeItem.h"
#import "coffeeTableViewCell.h"
#import "coffeeDetailViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "coffeeImageTableViewCell.h"


/*Displays list of coffees */


static NSString *CellImageIdentifier = @"CellImageIdentifier";
static NSString *CellTextIdentifier = @"CellTextIdentifier";



@interface coffeeTableViewController ()
	@property (nonatomic,strong) NSMutableArray * coffeeImageArray;
	@property (nonatomic,strong) NSMutableDictionary *tableCells;
	@property (nonatomic) BOOL enableInteraction;

@end

@implementation coffeeTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
		self.tableCells=[NSMutableDictionary dictionary];
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIImage *image = [UIImage imageNamed:@"whitelogo"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
	
    self.navigationItem.titleView=imageView;

	[self.tableView setSeparatorInset:UIEdgeInsetsZero];
	
	
	
    [[RACObserve([coffeeManager sharedManager], coffeArray)  //If the property of coffeArray of coffeeManager object changes the block in subscriber next will be executed
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(NSArray *coffeeArray) {
		 self.coffeeImageArray = [[NSMutableArray alloc] init];
		 for (unsigned i = 0; i < [coffeeArray count]; i++) {
			 [self.coffeeImageArray addObject:[NSNull null]];
		 }
         [self.tableView reloadData];
     }];
	
	
	
	//Send request to get the list of coffees

	[[coffeeManager sharedManager] getCoffeItems:^(NSString *errorReason) {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorReason
														message:nil
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
        
        
		[alert show]; //Show error
		
		
	}];
	
}


-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.enableInteraction=YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[coffeeManager sharedManager].coffeArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	if([self hasImage:indexPath])
	{
		return[self heightForImageCellAtIndexPath:indexPath]; //has image

	}
	

	
	return [self heightForTextCellAtIndexPath:indexPath]; //no image
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	
	
	
	
	if([self hasImage:indexPath]){
		
		return [self imageCellatIndexpath:indexPath]; //has image
		
	}
	
	
	//No image
	
	NSString * CellIdentifier=CellTextIdentifier;
		
	
	
	
    coffeeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
	if(cell == nil)
	{
		cell=[[coffeeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
	
		
	}
	
	if([coffeeManager sharedManager].coffeArray){
		
		coffeeItem *coffee=[coffeeManager sharedManager].coffeArray[indexPath.row];
		
		
		
		cell.coffeeTextLabel.text=coffee.coffeeName;
		
		cell.coffeeDetailTextLabel.text=coffee.coffeeDesc;
		
	
	}
	[cell setNeedsUpdateConstraints];
	[cell updateConstraintsIfNeeded];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (UITableViewCell *)imageCellatIndexpath:(NSIndexPath *)indexPath{
	
	NSString * CellIdentifier=CellImageIdentifier;
	coffeeImageTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	// Configure the cell...
	if(cell == nil)
	{
		cell=[[coffeeImageTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		
		
	}
	
		
	if([coffeeManager sharedManager].coffeArray){
		
		coffeeItem *coffee=[coffeeManager sharedManager].coffeArray[indexPath.row];
		
		cell.coffeeTextLabel.text=coffee.coffeeName;
		
		cell.coffeeDetailTextLabel.text=coffee.coffeeDesc;
		
		
		
		if(self.coffeeImageArray[indexPath.row] != [NSNull null]){  //Check whether Image already exists
			cell.coffeeImageView.image=self.coffeeImageArray[indexPath.row];
			
		
		}
		
	}
	
	[cell setNeedsUpdateConstraints];
	[cell updateConstraintsIfNeeded];
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;

	
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if([self hasImage:indexPath])
		return 154;
	else
		return 54;

}




-(BOOL) hasImage:(NSIndexPath *)indexPath
{
	coffeeItem *coffee=[coffeeManager sharedManager].coffeArray[indexPath.row];
	if([coffee.coffeeImageUrl isEqualToString:@""])
		return NO;     //No image url
	else
		return YES;
}


//Dynamically calculate the cell height
- (CGFloat)heightForImageCellAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *reuseIdentifier = CellImageIdentifier;
	
	
	coffeeImageTableViewCell *cell = [self.tableCells objectForKey:reuseIdentifier];
	if (!cell) {
		cell = [[coffeeImageTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
		[self.tableCells setObject:cell forKey:reuseIdentifier];
	}
	
	
	
	if([coffeeManager sharedManager].coffeArray){
		
		coffeeItem *coffee=[coffeeManager sharedManager].coffeArray[indexPath.row];
		
		cell.coffeeTextLabel.text=coffee.coffeeName;
		
		cell.coffeeDetailTextLabel.text=coffee.coffeeDesc;
		
		
		__weak coffeeTableViewController * weakself=self;
		if(self.coffeeImageArray[indexPath.row] != [NSNull null]){  //Check whether Image already exists
			cell.coffeeImageView.image=self.coffeeImageArray[indexPath.row];
			
		}else if(![coffee.coffeeImageUrl isEqualToString:@""]){ //If not get it from server
			[[coffeeManager sharedManager] downloadImagewitthUrlString:coffee.coffeeImageUrl completionBlock:^(UIImage *image,BOOL succeeded) {
				
				if (succeeded) {
					
					
					
					if(image.size.height>100) {  //Scale the image if it is too big.
						CGFloat scalefactor=image.size.height/100;
						CGSize destinationSize = CGSizeMake(image.size.width/scalefactor, image.size.height/scalefactor);
						UIGraphicsBeginImageContext(destinationSize);
						[image drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
						UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
						UIGraphicsEndImageContext();
						
						
						 
						weakself.coffeeImageArray[indexPath.row] = newImage;
						
					
					}else
					{
						weakself.coffeeImageArray[indexPath.row]=image;
					}
					
					NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
					[weakself.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation: UITableViewRowAnimationNone];
					
				}
				
			}];
			
		}
	}

	
	
	[cell setNeedsUpdateConstraints];
	[cell updateConstraintsIfNeeded];
	
	
	cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(cell.bounds));
	
	[cell setNeedsLayout];
	[cell layoutIfNeeded];
	
	
	CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
	
	
	height += 1;
	
	return height;
}


//Dynamically calculate the height of cell without image
- (CGFloat)heightForTextCellAtIndexPath:(NSIndexPath *)indexPath{
	
	NSString *reuseIdentifier = CellTextIdentifier;
	
	
	coffeeTableViewCell *cell = [self.tableCells objectForKey:reuseIdentifier];
	if (!cell) {
		cell = [[coffeeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
		[self.tableCells setObject:cell forKey:reuseIdentifier];
	}
	
	
	
	if([coffeeManager sharedManager].coffeArray){
		
		coffeeItem *coffee=[coffeeManager sharedManager].coffeArray[indexPath.row];
		
		cell.coffeeTextLabel.text=coffee.coffeeName;
		
		cell.coffeeDetailTextLabel.text=coffee.coffeeDesc;
		
		
	}
	
	
	
	[cell setNeedsUpdateConstraints];
	[cell updateConstraintsIfNeeded];
	
	
	cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(cell.bounds));
	
	[cell setNeedsLayout];
	[cell layoutIfNeeded];
	
	
	CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
	

	height += 1;
	
	return height;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if([coffeeManager sharedManager].coffeArray && self.enableInteraction)
	{
		self.enableInteraction=NO;
		coffeeDetailViewController *coffeeDetailController=[[coffeeDetailViewController alloc] init];
		coffeeItem *coffee=[coffeeManager sharedManager].coffeArray[indexPath.row];
		coffeeDetailController.coffeeId=coffee.coffeeId;
		UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
		self.navigationItem.backBarButtonItem = barBtnItem;
		self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
		[self.navigationController pushViewController:coffeeDetailController animated:YES]; //Show the detail of selected coffee
		
	}
	
}



@end
