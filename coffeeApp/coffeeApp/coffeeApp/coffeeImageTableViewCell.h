//
//  coffeeImageTableViewCell.h
//  coffeeApp
//
//  Created by Dhurjatiprasad Nath on 1/19/15.
//  Copyright (c) 2015 Prasad. All rights reserved.
//
//Tableview cell with image

#import <UIKit/UIKit.h>

@interface coffeeImageTableViewCell : UITableViewCell

	@property (strong,nonatomic) UILabel *coffeeTextLabel;
	@property (strong,nonatomic) UILabel *coffeeDetailTextLabel;
	@property (strong,nonatomic) UIImageView *coffeeImageView;

@end
