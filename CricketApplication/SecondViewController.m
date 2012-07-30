//
//  SecondViewController.m
//  CricketApplication
//
//  Created by Rob Lloyd on 30/07/2012.
//  Copyright (c) 2012 JMoni. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()
@property (strong, nonatomic) IBOutlet UIButton *homeWonToss;
@property (strong, nonatomic) IBOutlet UIButton *awayWonToss;
@property (strong, nonatomic) IBOutlet UIButton *battingButton;
@property (strong, nonatomic) IBOutlet UIButton *fieldingButton;

@end

@implementation SecondViewController
@synthesize homePlayersTable;
@synthesize awayPlayersTable;
@synthesize homeWonToss;
@synthesize awayWonToss;
@synthesize battingButton;
@synthesize fieldingButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[homeWonToss addTarget:self action:@selector(tossButtonManage) forControlEvents:UIControlEventTouchUpInside];
	[awayWonToss addTarget:self action:@selector(tossButtonManage) forControlEvents:UIControlEventTouchUpInside];
	[battingButton addTarget:self action:@selector(decisionButtonManage) forControlEvents:UIControlEventTouchUpInside];
	[fieldingButton addTarget:self action:@selector(decisionButtonManage) forControlEvents:UIControlEventTouchUpInside];
	homePlayersArray = [[NSMutableArray alloc] init];
	awayPlayersArray = [[NSMutableArray alloc] init];
	for (int i = 1; i < 12; i++){
		[homePlayersArray addObject:[NSString stringWithFormat:@"Player%d", i]];
		[awayPlayersArray addObject:[NSString stringWithFormat:@"Player%d", i]];
	}
}

- (void)viewDidUnload
{
	[self setHomePlayersTable:nil];
	[self setAwayPlayersTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	[self setHomeWonToss:nil];
	[self setAwayWonToss:nil];
	[self setBattingButton:nil];
	[self setFieldingButton:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int cellNumber = 0;
	if ([tableView isEqual:homePlayersTable])
    {
		cellNumber = [homePlayersArray count];
	} else if ([tableView isEqual:awayPlayersTable]) {
		cellNumber = [awayPlayersArray count];
	}
    return cellNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	
    // configure your cell here...
	if ([tableView isEqual:homePlayersTable])
    {
		cell.textLabel.text = [homePlayersArray objectAtIndex:indexPath.row];
	} else if ([tableView isEqual:awayPlayersTable]) {
		cell.textLabel.text = [awayPlayersArray objectAtIndex:indexPath.row];
	}
    return cell;
}

- (void)tossButtonManage
{
    if (homeWonToss.selected)
	{
        [homeWonToss setSelected:NO];
		[awayWonToss setSelected:YES];
    }
    else
	{
        [homeWonToss setSelected:YES];
		[awayWonToss setSelected:NO];
    }
}

- (void)decisionButtonManage
{
    if (battingButton.selected)
	{
        [battingButton setSelected:NO];
		[fieldingButton setSelected:YES];
    }
    else
	{
        [battingButton setSelected:YES];
		[fieldingButton setSelected:NO];
    }
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
