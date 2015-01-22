//
//  coffeeDetailViewController.m
//  coffeeApp
//
//  Created by Prasad on 10/29/14.
//  Copyright (c) 2014 Prasad. All rights reserved.
//


/*View Controller to display the details of the coffee */

#import "coffeeDetailViewController.h"

@interface coffeeDetailViewController ()

	
	@property (nonatomic,strong) UILabel *titledetail;
	@property (nonatomic,strong) UIView *lineView;
	@property (nonatomic,strong) UILabel *desc;
	@property (nonatomic,strong) UIImageView *coffeeImage;
	@property (nonatomic,strong) UILabel *updateTime;
	@property (copy, nonatomic) NSArray *constraints;
	@property (nonatomic) BOOL hasImage;

@end

@implementation coffeeDetailViewController



-(id)init
{
	self= [super init];
	
	if(self)
	{
		
		
	}
	
	return self;
}

-(void) loadView
{
	
	UIView *view = [[UIView alloc] init];
	view.backgroundColor = [UIColor whiteColor];
	self.view=view;
	UIImage *image = [UIImage imageNamed:@"whitelogo"];
	UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	
	
	self.navigationItem.titleView=imageView;
	
	UIButton *bt=[UIButton buttonWithType:UIButtonTypeCustom];
	[bt setFrame:CGRectMake(0, 0, 80, 30)];
	
	bt.layer.borderColor = [UIColor whiteColor].CGColor;
	bt.layer.borderWidth = 2.0f;
	
   
	[bt addTarget:self action:@selector(shareButtonclicked:) forControlEvents:UIControlEventTouchUpInside];
	[bt setTitle:@"Share" forState:UIControlStateNormal];
	bt.showsTouchWhenHighlighted = TRUE;
	UIBarButtonItem *leftButton=[[UIBarButtonItem alloc] initWithCustomView:bt]; //UIBarButtonItemStyleBordered depreciated ios 8 need to use this work around
	self.navigationItem.rightBarButtonItem=leftButton;
	
	self.titledetail=[UILabel new];
	[self.titledetail setTranslatesAutoresizingMaskIntoConstraints:NO];
	
	unsigned rgbValue=0x666666;
	
	self.titledetail.textColor=[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
	
	
	
	[self.view addSubview:self.titledetail];
	
	self.lineView = [UIView new];
	
	rgbValue=0xAAAAAA;
	
	self.lineView.backgroundColor = [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
	[self.lineView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.view addSubview:self.lineView];
	
	
	self.desc=[UILabel new];
	self.desc.textColor=[UIColor darkGrayColor];
	self.desc.numberOfLines = 0;
	self.desc.adjustsFontSizeToFitWidth = YES;
  
	[self.desc setTranslatesAutoresizingMaskIntoConstraints:NO];
	
	
	self.desc.textColor=[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
	
	
	[self.view addSubview:self.desc];
	
	self.coffeeImage =[UIImageView new];
	[self.coffeeImage setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.view addSubview:self.coffeeImage];
	
	
	self.updateTime=[UILabel new];
	
	self.updateTime.textColor=[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
	
	[self.updateTime setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.view addSubview:self.updateTime];


	
	[coffeeManager sharedManager].coffeeDetail=nil;
	
	
	__weak coffeeDetailViewController * weakSelf = self;
	
	[[coffeeManager sharedManager] getCoffeeDetail:self.coffeeId completionBlock:^(coffeeDetail *detail) {
		
		if(!weakSelf)
			return;
		
		weakSelf.titledetail.text=detail.coffeeName;
		
		NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
		paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
		paragraphStyle.alignment = NSTextAlignmentJustified;
		
		NSAttributedString *string = [[NSAttributedString alloc] initWithString:detail.coffeeDesc
																	 attributes:[NSDictionary dictionaryWithObjectsAndKeys:
																				 paragraphStyle, NSParagraphStyleAttributeName ,
																				 [NSNumber numberWithFloat:0],NSBaselineOffsetAttributeName,
																				 nil]];
		
		weakSelf.desc.attributedText=string; //Text justification
		
		
		
		NSString *prevdate=detail.lastUpdated;
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		
		[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
		
		
		NSDate *date = [dateFormatter dateFromString:prevdate];
		NSDate *date1 = [[NSDate alloc] init];
		
		// Get conversion to months, days, hours, minutes
		unsigned int unitFlags = kCFCalendarUnitSecond| NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | kCFCalendarUnitYear | kCFCalendarUnitWeekOfYear;
		
		NSCalendar *sysCalendar = [NSCalendar currentCalendar];
		
		NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:date  toDate:date1  options:0];
		
		NSString *updatedsince;
		
		if([breakdownInfo year]!=0)
		{
			updatedsince=[NSString stringWithFormat:@"Updated %tu %@ ago",[breakdownInfo year], ([breakdownInfo year]==1)?@"year":@"years"];
		} else if([breakdownInfo month]!=0)
		{
			updatedsince=[NSString stringWithFormat:@"Updated %tu %@ ago",[breakdownInfo month], ([breakdownInfo month]==1)?@"month":@"months"];
		} else if([breakdownInfo weekOfYear]!=0)
		{
			updatedsince=[NSString stringWithFormat:@"Updated %tu %@ ago",[breakdownInfo weekOfYear], ([breakdownInfo weekOfYear]==1)?@"week":@"weeks"];
			
		}
		else if ([breakdownInfo day]!=0)
		{
			updatedsince=[NSString stringWithFormat:@"Updated %tu %@ ago",[breakdownInfo day], ([breakdownInfo day]==1)?@"day":@"days"];
		}else if([breakdownInfo hour]!=0)
		{
			updatedsince=[NSString stringWithFormat:@"Updated %tu %@ ago",[breakdownInfo hour], ([breakdownInfo hour]==1)?@"hour":@"hours"];
		} else if([breakdownInfo minute]!=0)
		{
			updatedsince=[NSString stringWithFormat:@"Updated %tu %@ ago",[breakdownInfo minute], ([breakdownInfo minute]==1)?@"minute":@"minutes"];
		} else if([breakdownInfo second]!=0)
		{
			updatedsince=[NSString stringWithFormat:@"Updated %tu %@ ago",[breakdownInfo second], ([breakdownInfo second]==1)?@"second":@"seconds"];
		}
		
		weakSelf.updateTime.text=updatedsince;
		
		
		
		if( ![detail.coffeeImageUrl isEqualToString:@""])
			[[coffeeManager sharedManager] downloadImagewitthUrlString:detail.coffeeImageUrl completionBlock:^(UIImage *image,BOOL succeeded) {
				
				if (succeeded) {
					
					if(!weakSelf)
						return;
					dispatch_async( dispatch_get_main_queue(), ^{
						weakSelf.coffeeImage.image=image;
						
						
						
						if(NSClassFromString(@"UITraitCollection")) {  //ios8+
							[weakSelf updateConstraints:weakSelf.traitCollection];
						} else { //ios 7.1
							UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
							[weakSelf updateViewConstraintsiOS7:orientation];
						}

						
					});
					
				}
				
			}];
		else{
			if(NSClassFromString(@"UITraitCollection")) { //ios8+
				[weakSelf updateConstraints:weakSelf.traitCollection];
			} else { //ios 7.1
				UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
				[weakSelf updateViewConstraintsiOS7:orientation];
			}

		}
		
	} errorBlock:^(NSString *errorReason) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorReason
														message:nil
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show]; //Show error
		
		
	}
	 ];

   
}


- (void)viewDidLoad
{
	[super viewDidLoad];
	
	
}

//ios 7.1
-(void)updateViewConstraintsiOS7:(UIInterfaceOrientation)orientation
{
	NSDictionary *viewsDictionary = @{ @"topLayoutGuide": self.topLayoutGuide, @"titledetail":self.titledetail , @"lineView":self.lineView,@"desc":self.desc,@"coffeeImage":self.coffeeImage,@"updateTime":self.updateTime };
	
 
	
	NSMutableArray *newConstraints = [NSMutableArray array];
	
	
	
	if(orientation == UIInterfaceOrientationPortrait){
		
		
		NSArray *constraint_POS_H_title = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[titledetail]"
																				  options:0
																				  metrics:nil
																					views:viewsDictionary];
		
		NSArray *constraint_POS_H_line = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[lineView]-10-|"
																				 options:0
																				 metrics:nil
																				   views:viewsDictionary];
		
		NSArray *constraint_POS_H_desc = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[desc]-10-|"
																				 options:0
																				 metrics:nil
																				   views:viewsDictionary];
		
	
		
		
		NSArray *constraint_POS_H_updttime = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[updateTime]-10-|"
																					 options:0
																					 metrics:nil
																					   views:viewsDictionary];
		
		
		if(self.coffeeImage.image){
			
			NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide]-[titledetail]-10-[lineView(1)]-10-[desc]-10-[coffeeImage]-10-[updateTime]-(>=10)-|"
																				options:0
																				metrics:nil
																				  views:viewsDictionary];
			NSArray *constraint_POS_H_im = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[coffeeImage]-(>=10)-|"
																				   options:0
																				   metrics:nil
																					 views:viewsDictionary];
			
			[newConstraints addObjectsFromArray:constraint_POS_V];
			[newConstraints addObjectsFromArray:constraint_POS_H_im];

			
			NSLayoutConstraint *constraintAspect = [NSLayoutConstraint constraintWithItem:self.coffeeImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.coffeeImage attribute:NSLayoutAttributeWidth multiplier:(self.coffeeImage.image.size.height/self.coffeeImage.image.size.width) constant:0.0];//Keeping the aspect ratio
			[newConstraints addObject:constraintAspect];
			
			CGRect screenBounds = [[UIScreen mainScreen] bounds];
			if (screenBounds.size.height < 568){ //for small screen
			
				NSLayoutConstraint *constraintExtra1 = [NSLayoutConstraint constraintWithItem:self.coffeeImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:(0.40) constant:0]; //Needed to accomodate all the elements in small screen. Some time the vertical contraint constraint_POS_V alone is not sufficient. Probably this is a bug in objective C.
					
			
				[self.titledetail setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
				
				[self.desc setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
				
				[self.updateTime setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
					
				[newConstraints addObject:constraintExtra1];
			
			}
		} else {
			NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide]-[titledetail]-10-[lineView(1)]-10-[desc]-10-[updateTime]-(>=10)-|"
																				options:0
																				metrics:nil
																				  views:viewsDictionary];
			
			[newConstraints addObjectsFromArray:constraint_POS_V];
		}
		
		
		
		
		
		[newConstraints addObjectsFromArray:constraint_POS_H_title];
		
		[newConstraints addObjectsFromArray:constraint_POS_H_line];
		
		[newConstraints addObjectsFromArray:constraint_POS_H_desc];
		
		
		[newConstraints addObjectsFromArray:constraint_POS_H_updttime];
		
		
	} else {
		
		NSArray *constraint_POS_H_title = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[titledetail]-10-|"
																				  options:0
																				  metrics:nil
																					views:viewsDictionary];
		
		
		
		
		NSArray *constraint_POS_V_2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide]-[titledetail]-10-[lineView(1)]-10-[desc]-(>=10)-[updateTime]"
																			  options:0
																			  metrics:nil
																				views:viewsDictionary];
		
		
  
		
		
		
		NSArray *constraint_POS_H_line = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[lineView]-10-|"
																				 options:0
																				 metrics:nil
																				   views:viewsDictionary];
		
		
		
		
		
		
		NSArray *constraint_POS_H_updttime = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[updateTime]-10-|"
																					 options:0
																					 metrics:nil
																					   views:viewsDictionary];
		
		
		
		
		
		
		if(self.coffeeImage.image) {
			
			
			NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.desc attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0.0];
			
			[newConstraints addObject:constraint];
			
			NSArray *constraint_POS_H_desc = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[desc]-10-[coffeeImage]-(>=10)-|"
																					 options:0
																					 metrics:nil
																					   views:viewsDictionary];
			
			NSArray *constraint_POS_V_1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide]-[titledetail]-10-[lineView(1)]-10-[coffeeImage]-10-[updateTime]-(>=10)-|"
																				  options:0
																				  metrics:nil
																					views:viewsDictionary];
			[newConstraints addObjectsFromArray:constraint_POS_V_1];
			[newConstraints addObjectsFromArray:constraint_POS_H_desc];

			
			NSLayoutConstraint *constraintAspect = [NSLayoutConstraint constraintWithItem:self.coffeeImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.coffeeImage attribute:NSLayoutAttributeWidth multiplier:(self.coffeeImage.image.size.height/self.coffeeImage.image.size.width) constant:0.0]; //Maintain aspect ratio
			
			[newConstraints addObject:constraintAspect];
			
			NSLayoutConstraint *constraintExtra = [NSLayoutConstraint constraintWithItem:self.coffeeImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:(0.55) constant:0];
			
			//Needed to accomodate all the elements in landscape. Some time the vertical contraint constraint_POS_V_1 and constraint_POS_V_2 alone are not sufficient. Probably this is a bug in objective C.
			
			
			[newConstraints addObject:constraintExtra];

		} else {
			NSArray *constraint_POS_H_desc = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[desc]-10-|"
																					 options:0
																					 metrics:nil
																					   views:viewsDictionary];
			[newConstraints addObjectsFromArray:constraint_POS_H_desc];

		}
		
	
		
		[newConstraints addObjectsFromArray:constraint_POS_V_2];
		
		
		
		
		[newConstraints addObjectsFromArray:constraint_POS_H_title];
		
		[newConstraints addObjectsFromArray:constraint_POS_H_line];
		
		
		
		
		[newConstraints addObjectsFromArray:constraint_POS_H_updttime];
		
		
		
		
	}
	if (self.constraints) {
		
		[self.view removeConstraints:self.constraints];
	}
	
	
	self.constraints=newConstraints;
	[self.view addConstraints:self.constraints];
	
}

//ios8+
- (void)updateConstraints:(UITraitCollection *)collection
{


   NSDictionary *viewsDictionary = @{ @"topLayoutGuide": self.topLayoutGuide, @"titledetail":self.titledetail , @"lineView":self.lineView,@"desc":self.desc,@"coffeeImage":self.coffeeImage,@"updateTime":self.updateTime };
	
 
	
	NSMutableArray *newConstraints = [NSMutableArray array];
   
	if(collection.verticalSizeClass!=UIUserInterfaceSizeClassCompact){
	
		
		
		NSArray *constraint_POS_H_title = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[titledetail]"
																				  options:0
																				  metrics:nil
																					views:viewsDictionary];
		
		NSArray *constraint_POS_H_line = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[lineView]-10-|"
																				 options:0
																				 metrics:nil
																				   views:viewsDictionary];
		
		NSArray *constraint_POS_H_desc = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[desc]-10-|"
																				 options:0
																				 metrics:nil
																				   views:viewsDictionary];
		
		
		
		
		NSArray *constraint_POS_H_updttime = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[updateTime]-10-|"
																					 options:0
																					 metrics:nil
																					   views:viewsDictionary];
		
	   
		
			if(self.coffeeImage.image){
				
				NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide]-[titledetail]-10-[lineView(1)]-10-[desc]-10-[coffeeImage]-10-[updateTime]-(>=10)-|"
																					options:0
																					metrics:nil
																					  views:viewsDictionary];
				
				[newConstraints addObjectsFromArray:constraint_POS_V];
				
				NSArray *constraint_POS_H_im = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[coffeeImage]-(>=10)-|"
																					   options:0
																					   metrics:nil
																						 views:viewsDictionary];
				
				[newConstraints addObjectsFromArray:constraint_POS_H_im];

				
				NSLayoutConstraint *constraintAspect = [NSLayoutConstraint constraintWithItem:self.coffeeImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.coffeeImage attribute:NSLayoutAttributeWidth multiplier:(self.coffeeImage.image.size.height/self.coffeeImage.image.size.width) constant:0.0];
					[newConstraints addObject:constraintAspect];
				
				
				CGRect screenBounds = [[UIScreen mainScreen] bounds];
				if (screenBounds.size.height < 568){ //for small screen
					
					NSLayoutConstraint *constraintExtra1 = [NSLayoutConstraint constraintWithItem:self.coffeeImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:(0.40) constant:0];//Needed to accomodate all the elements in small screen. Some time the vertical contraint constraint_POS_V alone is not sufficient. Probably this is a bug in objective C.
					
					
					
					[self.titledetail setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
					
					[self.desc setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
					
					[self.updateTime setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
					
					[newConstraints addObject:constraintExtra1];
					
				}
				
			} else {
				NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide]-[titledetail]-10-[lineView(1)]-10-[desc]-10-[updateTime]-(>=10)-|"
																					options:0
																					metrics:nil
																					  views:viewsDictionary];
				[newConstraints addObjectsFromArray:constraint_POS_V];

			}
		
		
		
		[newConstraints addObjectsFromArray:constraint_POS_H_title];
		
		[newConstraints addObjectsFromArray:constraint_POS_H_line];
		
		[newConstraints addObjectsFromArray:constraint_POS_H_desc];
		
		
		[newConstraints addObjectsFromArray:constraint_POS_H_updttime];
		
		
	} else {
		
		NSArray *constraint_POS_H_title = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[titledetail]-10-|"
																				  options:0
																				  metrics:nil
																					views:viewsDictionary];
		
		
		
		
		
		NSArray *constraint_POS_V_2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide]-[titledetail]-10-[lineView(1)]-10-[desc]-(>=10)-[updateTime]"
																			  options:0
																			  metrics:nil
																				views:viewsDictionary];

		
  
		
	   
		
		NSArray *constraint_POS_H_line = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[lineView]-10-|"
																				 options:0
																				 metrics:nil
																				   views:viewsDictionary];
		
	   
		
	   
		
		
		NSArray *constraint_POS_H_updttime = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[updateTime]-10-|"
																					 options:0
																					 metrics:nil
																					   views:viewsDictionary];
		
	  
		
		
		
		
		if(self.coffeeImage.image){
			
			NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.desc attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.5 constant:0.0];
			
			[newConstraints addObject:constraint];
			
			
			NSLayoutConstraint *constraintAspect = [NSLayoutConstraint constraintWithItem:self.coffeeImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.coffeeImage attribute:NSLayoutAttributeWidth multiplier:(self.coffeeImage.image.size.height/self.coffeeImage.image.size.width) constant:0.0]; //Maintain aspect ratio
			[newConstraints addObject:constraintAspect];
		
		
			NSArray *constraint_POS_V_1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide]-[titledetail]-10-[lineView(1)]-10-[coffeeImage]-10-[updateTime]-(>=10)-|"
																				  options:0
																				  metrics:nil
																					views:viewsDictionary];
			
			[newConstraints addObjectsFromArray:constraint_POS_V_1];
			
			NSArray *constraint_POS_H_desc = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[desc]-10-[coffeeImage]-(>=10)-|"
																					 options:0
																					 metrics:nil
																					   views:viewsDictionary];
			
			[newConstraints addObjectsFromArray:constraint_POS_H_desc];
		
			NSLayoutConstraint *constraintExtra = [NSLayoutConstraint constraintWithItem:self.coffeeImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:(0.60) constant:0];//Needed to accomodate all the elements in landscape. Some time the vertical contraint constraint_POS_V_1 and  constraint_POS_V_2 alone are not sufficient. Probably this is a bug in objective C.

			[newConstraints addObject:constraintExtra];
		} else {
			
			
			NSArray *constraint_POS_H_desc = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[desc]-(>=10)-|"
																					 options:0
																					 metrics:nil
																					   views:viewsDictionary];
			
			[newConstraints addObjectsFromArray:constraint_POS_H_desc];

		}
	
		[newConstraints addObjectsFromArray:constraint_POS_V_2];
		
		
		[newConstraints addObjectsFromArray:constraint_POS_H_title];
		
		[newConstraints addObjectsFromArray:constraint_POS_H_line];
		
		
		
		
		[newConstraints addObjectsFromArray:constraint_POS_H_updttime];
		
		
		
	   
		
	}
	if (self.constraints) {
		
		
		 [NSLayoutConstraint deactivateConstraints:self.constraints];
	}
	
	
	self.constraints=newConstraints;
	

	[NSLayoutConstraint activateConstraints:self.constraints];
   

}

//Orientation changing ios 8
- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
	[super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
	
	[coordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext> context) {
		 [self updateConstraints:newCollection];
		 [self.view setNeedsLayout];
	} completion:nil];
}

//Orientation changing ios7
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
								duration:(NSTimeInterval)duration{
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[self updateViewConstraintsiOS7:toInterfaceOrientation];
	
	
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


-(void) viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	if (self.constraints) {
		
		if([NSLayoutConstraint respondsToSelector:@selector(activateConstraints:)]){//ios8+
			
			[NSLayoutConstraint deactivateConstraints:self.constraints];
		}else {
			[self.view removeConstraints:self.constraints];
			
		}
	}
	[self.desc removeFromSuperview];
	[self.titledetail removeFromSuperview];
	[self.lineView removeFromSuperview];
	
	[self.coffeeImage removeFromSuperview];
	[self.updateTime removeFromSuperview];
	
	
}

-(void)shareButtonclicked:(id)sender //Share
{
	
	
	UIActivityViewController *activityViewController;
	
	if(self.coffeeImage.image)
		activityViewController=[[UIActivityViewController alloc] initWithActivityItems:@[self.titledetail.text, self.desc.text,self.coffeeImage.image,self.updateTime.text] applicationActivities:nil];
	else
		activityViewController=[[UIActivityViewController alloc] initWithActivityItems:@[self.titledetail.text, self.desc.text,self.updateTime.text] applicationActivities:nil];
		
	[self presentViewController:activityViewController
									   animated:YES
									 completion:^{
										 // ...
									 }];
}



@end
