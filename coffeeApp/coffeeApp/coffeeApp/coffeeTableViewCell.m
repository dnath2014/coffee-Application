//
//  coffeeTableViewCell.m
//  coffeeApp
//
//  Created by Prasad on 10/28/14.
//  Copyright (c) 2014 Prasad. All rights reserved.
//


//Tableview cell without image

#import "coffeeTableViewCell.h"

@interface coffeeTableViewCell ()
	@property (nonatomic) BOOL didSetupConstraints;
@end

@implementation coffeeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		self.coffeeTextLabel = [UILabel new];
		self.coffeeTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
		
		self.coffeeTextLabel.font = [UIFont systemFontOfSize:10];
		self.coffeeTextLabel.adjustsFontSizeToFitWidth = YES;
		
		
		
		unsigned rgbValue=0x666666;
		
		self.coffeeTextLabel.textColor=[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
		
		
		
		self.coffeeDetailTextLabel = [UILabel new];
		self.coffeeDetailTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
		
		self.coffeeDetailTextLabel.font = [UIFont systemFontOfSize:10];
		
		
		self.coffeeDetailTextLabel.numberOfLines = 2;
		self.coffeeDetailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
		
		rgbValue=0xAAAAAA;
		
		self.coffeeDetailTextLabel.textColor=[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
		
		[self.contentView addSubview:self.coffeeTextLabel];
		[self.contentView addSubview:self.coffeeDetailTextLabel];
		
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateConstraints
{
	if (!self.didSetupConstraints) {
		
		NSMutableArray *newConstraints = [NSMutableArray array];
		
		NSDictionary *viewsDictionary = @{@"coffeeTextLabel":self.coffeeTextLabel , @"coffeeDetailTextLabel":self.coffeeDetailTextLabel};
		
		
		self.coffeeDetailTextLabel.preferredMaxLayoutWidth=self.contentView.bounds.size.width-20;
		//This is necessary otherwise uilabel does not show multiline
		
		
		
		NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[coffeeTextLabel]-[coffeeDetailTextLabel]-5-|"
																			options:0
																			metrics:nil
																			  views:viewsDictionary];
		
		
		NSArray *constraint_POS_H1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[coffeeTextLabel]"
																			 options:0
																			 metrics:nil
																			   views:viewsDictionary];
		
		NSArray *constraint_POS_H2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[coffeeDetailTextLabel]"
																			 options:0
																			 metrics:nil
																			   views:viewsDictionary];
		
		
		
		
		
		
		[newConstraints addObjectsFromArray:constraint_POS_V];
		[newConstraints addObjectsFromArray:constraint_POS_H1];
		[newConstraints addObjectsFromArray:constraint_POS_H2];
		
		
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
