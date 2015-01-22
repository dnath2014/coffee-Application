//
//  coffeeImageTableViewCell.m
//  coffeeApp
//
//  Created by Dhurjatiprasad Nath on 1/19/15.
//  Copyright (c) 2015 Prasad. All rights reserved.
//

//Tableview cell with image


#import "coffeeImageTableViewCell.h"

@interface coffeeImageTableViewCell ()

	@property (nonatomic, assign) BOOL didSetupConstraints;
	

@end

static NSString *CellIdentifier = @"CellImageIdentifier";

@implementation coffeeImageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		
		self.coffeeTextLabel = [UILabel new];
		self.coffeeTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
		
		self.coffeeTextLabel.font = [UIFont systemFontOfSize:10];
		self.coffeeTextLabel.adjustsFontSizeToFitWidth = YES;
		
		
		
		unsigned rgbValue=0x666666;
		
		self.coffeeTextLabel.textColor=[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
		
		
		
		self.coffeeDetailTextLabel = [UILabel new];
		self.coffeeDetailTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
		
		self.coffeeDetailTextLabel.font = [UIFont systemFontOfSize:10];
		
		
		
		self.coffeeDetailTextLabel.font = [UIFont systemFontOfSize:10];
		
		self.coffeeDetailTextLabel.numberOfLines = 0;
		self.coffeeDetailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
		
		rgbValue=0xAAAAAA;
		
		self.coffeeDetailTextLabel.textColor=[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
		
		
		
		
		self.coffeeImageView=[UIImageView new];
		[self.coffeeImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
		
		
		[self.contentView addSubview:self.coffeeTextLabel];
		[self.contentView addSubview:self.coffeeDetailTextLabel];
		[self.contentView addSubview:self.coffeeImageView];
		
		self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
		
	}
	return self;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)updateConstraints
{
	if (!self.didSetupConstraints) {
		
		
		NSMutableArray *newConstraints = [NSMutableArray array];
		
		NSDictionary *viewsDictionary = @{@"coffeeTextLabel":self.coffeeTextLabel , @"coffeeDetailTextLabel":self.coffeeDetailTextLabel,@"coffeeImageView":self.coffeeImageView};

		
		NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[coffeeTextLabel]-[coffeeDetailTextLabel]-5-[coffeeImageView]-|"
																			options:0
																			metrics:nil
																			  views:viewsDictionary];
		
		
		NSArray *constraint_POS_H1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[coffeeTextLabel]"
																			options:0
																			metrics:nil
																			  views:viewsDictionary];
		
		NSArray *constraint_POS_H2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[coffeeDetailTextLabel]-(>=20)-|"
																			options:0
																			metrics:nil
																			  views:viewsDictionary];
		
		NSArray *constraint_POS_H3 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[coffeeImageView]"
																			options:0
																			metrics:nil
																			  views:viewsDictionary];




		

		
		[newConstraints addObjectsFromArray:constraint_POS_V];
		[newConstraints addObjectsFromArray:constraint_POS_H1];
		[newConstraints addObjectsFromArray:constraint_POS_H2];
		[newConstraints addObjectsFromArray:constraint_POS_H3];
	
		
		
		[self.contentView addConstraints:newConstraints];
		
		self.didSetupConstraints = YES;
	}
	
	[super updateConstraints];
}



- (void)layoutSubviews
{
	[super layoutSubviews];
	[self.contentView setNeedsLayout];
	[self.contentView layoutIfNeeded];
	
	
}



@end
