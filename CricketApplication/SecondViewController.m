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
	[homePlayersArray addObject:@"Player1"];
	[homePlayersArray addObject:@"Player2"];
	[homePlayersArray addObject:@"Player3"];
	[homePlayersArray addObject:@"Player4"];
	[homePlayersArray addObject:@"Player5"];
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
    return [homePlayersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	
    // configure your cell here...
	cell.textLabel.text = [homePlayersArray objectAtIndex:indexPath.row];
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
