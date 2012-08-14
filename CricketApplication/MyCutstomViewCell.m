//
//  MyCutstomViewCell.m
//  CricketApplication
//
//  Created by Miranda Aperghis on 14/08/2012.
//  Copyright (c) 2012 JMoni. All rights reserved.
//

#import "MyCutstomViewCell.h"

@implementation MyCutstomViewCell
@synthesize lblName;    //Player Name
@synthesize lblR;       //Runs
@synthesize lblM;       //Maiden
@synthesize lblB;       //Balls
@synthesize lbl4s;      //4s
@synthesize lbl6s;      //6s
@synthesize lblSR;      //Straight Runs

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
