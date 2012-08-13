//
//  DetailViewController.m
//  CricketApplication
//
//  Created by Rob Lloyd on 31/07/2012.
//  Copyright (c) 2012 JMoni. All rights reserved.
//

#import "DetailViewController.h"
#include "SecondViewController.h"
#include "DatabaseController.h"

@interface DetailViewController ()
@property (strong, nonatomic) IBOutlet UIPickerView *choosePlayer;

@end

int initialSliderValue;

@implementation DetailViewController
@synthesize playerEditTextBox = _playerEditTextBox;
@synthesize battingOrderSlider;
@synthesize sliderValueLabel;
@synthesize NavBar;
@synthesize CaptainSlider;
@synthesize ViceCaptainSlider;
@synthesize WicketKeeperSlider;
@synthesize previousPlayerButton;
@synthesize bottomToolbar;
@synthesize storedPlayersClicked = _storedPlayersClicked;
@synthesize nextPlayerButton;
@synthesize infoButtonItem = _infoButtonItem;

int height;
UIView *newView;
int playerInt;



- (IBAction)storedPlayersAction: (id)sender{
    NSLog(@"stored");
    _playerEditTextBox.enabled = false;
    _storedPlayersClicked.enabled = false;
    battingOrderSlider.enabled = false;
    CaptainSlider.enabled = false;
    ViceCaptainSlider.enabled = false;
    
    _playerEditTextBox.text = [displayPlayers objectAtIndex:0];
    
    height = 255;
    NSString *titleString;
    
    //create new view
    newView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, height)];
    newView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    
    //add toolbar
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, 320, 40)];
    toolbar.barStyle = UIBarStyleBlack;
    
    //add button
    _infoButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone     target:self action:@selector(hideActionSheet:)];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    titleString = @"Select Player";
    UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithTitle:titleString style:UIBarButtonItemStylePlain target:nil action:nil];
	
    toolbar.items = [NSArray arrayWithObjects:_infoButtonItem, spacer, titleButton, spacer, nil];
    
    
    //add a picker
    _choosePlayer = [[UIPickerView alloc] initWithFrame: CGRectMake(0,40,320,250)];
    _choosePlayer.hidden = false;
    _choosePlayer.delegate = self;
    _choosePlayer.dataSource = self;
    _choosePlayer.showsSelectionIndicator = YES;
    
    //Automatically scroll to the team already choosen
    [_choosePlayer selectRow:playerInt inComponent:0 animated:YES];
    [self pickerView:_choosePlayer didSelectRow:playerInt inComponent:0];

    //add popup view
    [newView addSubview:toolbar];
    [newView addSubview:_choosePlayer];
    [self.view addSubview:newView];
    
    //animate it onto the screen
    CGRect temp = newView.frame;
    temp.origin.y = CGRectGetMaxY(self.view.bounds);
    newView.frame = temp;
    [UIView beginAnimations:nil context:nil];
    temp.origin.y -= height;
    newView.frame = temp;
    [UIView commitAnimations];
    
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _playerEditTextBox.text = [displayPlayers objectAtIndex:row];
    playerInt = row;
}

//Number of rows in picker view
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [displayPlayers count];
}

//Values in picker view
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [displayPlayers objectAtIndex:row];
}


-(IBAction)hideActionSheet:(UIBarButtonItem *)_infoButtonItem{
    _playerEditTextBox.enabled = true;
    _storedPlayersClicked.enabled = true;
    battingOrderSlider.enabled = true;
    CaptainSlider.enabled = true;
    ViceCaptainSlider.enabled = true;
	
	//animate onto screen
	CGRect temp = newView.frame;
    temp.origin.y = height;
    newView.frame = temp;
    [UIView beginAnimations:nil context:nil];
    temp.origin.y += height;
    newView.frame = temp;
    [UIView commitAnimations];
	height = CGRectGetMaxY(self.view.bounds);
    [self changeArrayValue];
}

- (IBAction)textFieldReturn:(id)sender
{
	[self changeArrayValue];
	[_playerEditTextBox resignFirstResponder];
}

- (IBAction)backgroundTouched:(id)sender
{
	[self changeArrayValue];
	[_playerEditTextBox resignFirstResponder];
}

- (void)changeArrayValue{
	[arrayForDetailView replaceObjectAtIndex:rowForDetaiView withObject:[_playerEditTextBox text]];
}

- (IBAction)deletePlayer:(id)sender {
	UIAlertView* mes=[[UIAlertView alloc] initWithTitle:@""
				message:[NSString stringWithFormat:@"Are you sure you want to delete %@", [_playerEditTextBox text]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
	[mes show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
		[self resignFirstResponder];
	}
	else
	{
		if(teamForDetailView == @"home"){
			if (homeCaptain >= buttonIndex) homeCaptain--;
			if (homeViceCaptain >= buttonIndex) homeViceCaptain--;
			if (homeWicketKeeper >= buttonIndex) homeWicketKeeper--;
		} else if(teamForDetailView == @"away"){
			if (awayCaptain >= buttonIndex) awayCaptain--;
			if (awayViceCaptain >= buttonIndex) awayViceCaptain--;
			if (awayWicketKeeper >= buttonIndex) awayWicketKeeper--;
		}
		[self resignFirstResponder];
		[arrayForDetailView removeObjectAtIndex:rowForDetaiView];
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (IBAction)nextPlayer:(id)sender {
	rowForDetaiView += 1;
	
	if ([teamForDetailView isEqualToString:@"home"]) {
		self.playerEditTextBox.text = [arrayForDetailView objectAtIndex:rowForDetaiView];
		if (homeCaptain == rowForDetaiView)
			[self.CaptainSlider setOn:YES animated:YES];
		else
			[self.CaptainSlider setOn:NO animated:YES];
		if (homeViceCaptain == rowForDetaiView)
			[self.ViceCaptainSlider setOn:YES animated:YES];
		else
			[self.ViceCaptainSlider setOn:NO animated:YES];
		if (homeWicketKeeper == rowForDetaiView)
			[self.WicketKeeperSlider setOn:YES animated:YES];
		else
			[self.WicketKeeperSlider setOn:NO animated:YES];
	} else if ([teamForDetailView isEqualToString:@"away"]) {
		self.playerEditTextBox.text = [arrayForDetailView objectAtIndex:rowForDetaiView];
		if (awayCaptain == rowForDetaiView)
			[self.CaptainSlider setOn:YES animated:YES];
		else
			[self.CaptainSlider setOn:NO animated:YES];
		if (awayViceCaptain == rowForDetaiView)
			[self.ViceCaptainSlider setOn:YES animated:YES];
		else
			[self.ViceCaptainSlider setOn:NO animated:YES];
		if (awayWicketKeeper == rowForDetaiView)
			[self.WicketKeeperSlider setOn:YES animated:YES];
		else
			[self.WicketKeeperSlider setOn:NO animated:YES];
	}
	self.battingOrderSlider.value = rowForDetaiView+1.9;
	self.sliderValueLabel.text = [NSString stringWithFormat:@"%d", rowForDetaiView+1];
	[self viewDidLoad];
}

- (IBAction)previousPlayer:(id)sender {
	rowForDetaiView -= 1;
	if ([teamForDetailView isEqualToString:@"home"]) {
		self.playerEditTextBox.text = [homePlayersArray objectAtIndex:rowForDetaiView];
		if (homeCaptain == rowForDetaiView)
			[self.CaptainSlider setOn:YES animated:YES];
		else
			[self.CaptainSlider setOn:NO animated:YES];
		if (homeViceCaptain == rowForDetaiView)
			[self.ViceCaptainSlider setOn:YES animated:YES];
		else
			[self.ViceCaptainSlider setOn:NO animated:YES];
		if (homeWicketKeeper == rowForDetaiView)
			[self.WicketKeeperSlider setOn:YES animated:YES];
		else
			[self.WicketKeeperSlider setOn:NO animated:YES];
	} else if ([teamForDetailView isEqualToString:@"away"]) {
		self.playerEditTextBox.text = [awayPlayersArray objectAtIndex:rowForDetaiView];
		if (awayCaptain == rowForDetaiView)
			[self.CaptainSlider setOn:YES animated:YES];
		else
			[self.CaptainSlider setOn:NO animated:YES];
		if (awayViceCaptain == rowForDetaiView)
			[self.ViceCaptainSlider setOn:YES animated:YES];
		else
			[self.ViceCaptainSlider setOn:NO animated:YES];
		if (awayWicketKeeper == rowForDetaiView)
			[self.WicketKeeperSlider setOn:YES animated:YES];
		else
			[self.WicketKeeperSlider setOn:NO animated:YES];
	}
	self.battingOrderSlider.value = rowForDetaiView+1.9;
	self.sliderValueLabel.text = [NSString stringWithFormat:@"%d", rowForDetaiView+1];
	[self viewDidLoad];
}

- (IBAction)battingOrderSliderChanged:(id)sender {
	//NSLog([NSString stringWithFormat:@"after function: %d", initialSliderValue]);
	NSString *item = [arrayForDetailView objectAtIndex:(initialSliderValue-1)];
	[arrayForDetailView removeObject:item];
	[arrayForDetailView insertObject:item atIndex:(int)([battingOrderSlider value]-1)];
	if ([teamForDetailView isEqualToString:@"home"]) {
		if (homeCaptain == (initialSliderValue-1)) {
			homeCaptain = (int)([battingOrderSlider value]-1);
		} else if (homeCaptain > (initialSliderValue-1) && homeCaptain <= (int)([battingOrderSlider value]-1)) {
			homeCaptain--;
		} else if (homeCaptain < (initialSliderValue-1) && homeCaptain >= (int)([battingOrderSlider value]-1)) {
			homeCaptain++;
		}
		if (homeViceCaptain == (initialSliderValue-1)) {
			homeViceCaptain = (int)([battingOrderSlider value]-1);
		} else if (homeViceCaptain > (initialSliderValue-1) && homeViceCaptain <= (int)([battingOrderSlider value]-1)) {
			homeViceCaptain--;
		} else if (homeViceCaptain < (initialSliderValue-1) && homeViceCaptain >= (int)([battingOrderSlider value]-1)) {
			homeViceCaptain++;
		}
		if (homeWicketKeeper == (initialSliderValue-1)) {
			homeWicketKeeper = (int)([battingOrderSlider value]-1);
		}else if (homeWicketKeeper > (initialSliderValue-1) && homeWicketKeeper <= (int)([battingOrderSlider value]-1)) {
			homeWicketKeeper--;
		} else if (homeWicketKeeper < (initialSliderValue-1) && homeWicketKeeper >= (int)([battingOrderSlider value]-1)) {
			homeWicketKeeper++;
		}
	} else {
		if (awayCaptain == (initialSliderValue-1)) {
			awayCaptain = (int)([battingOrderSlider value]-1);
		} else if (awayCaptain > (initialSliderValue-1) && awayCaptain <= (int)([battingOrderSlider value]-1)) {
			awayCaptain--;
		} else if (awayCaptain < (initialSliderValue-1) && awayCaptain >= (int)([battingOrderSlider value]-1)) {
			awayCaptain++;
		}
		if (awayViceCaptain == (initialSliderValue-1)) {
			awayViceCaptain = (int)([battingOrderSlider value]-1);
		} else if (awayViceCaptain > (initialSliderValue-1) && awayViceCaptain <= (int)([battingOrderSlider value]-1)) {
			awayViceCaptain--;
		} else if (awayViceCaptain < (initialSliderValue-1) && awayViceCaptain >= (int)([battingOrderSlider value]-1)) {
			awayViceCaptain++;
		}
		if (awayWicketKeeper == (initialSliderValue-1)) {
			awayWicketKeeper = (int)([battingOrderSlider value]-1);
		}else if (awayWicketKeeper > (initialSliderValue-1) && awayWicketKeeper <= (int)([battingOrderSlider value]-1)) {
			awayWicketKeeper--;
		} else if (awayWicketKeeper < (initialSliderValue-1) && awayWicketKeeper >= (int)([battingOrderSlider value]-1)) {
			awayWicketKeeper++;
		}
	}
	rowForDetaiView = (int)([battingOrderSlider value]-1);
	[self viewDidLoad];
}

- (IBAction)battingOrderSliderChanging:(id)sender {
	sliderValueLabel.text = [NSString stringWithFormat:@"%d", (int)[battingOrderSlider value]];
}

- (IBAction)getInitialSlideValue:(id)sender {
	//NSLog([NSString stringWithFormat:@"%d", (int)[battingOrderSlider value]]);
	initialSliderValue = (int)[battingOrderSlider value];
}

- (IBAction)CSlider:(id)sender {
	if (CaptainSlider.on) {
		[ViceCaptainSlider setOn:NO animated:YES];
		if ([teamForDetailView isEqualToString:@"home"]) {
			homeCaptain = (int)[battingOrderSlider value]-1;
			if (homeViceCaptain == (int)[battingOrderSlider value]-1)
				homeViceCaptain = -1;
		} else {
			awayCaptain = (int)[battingOrderSlider value]-1;
			if (awayViceCaptain == (int)[battingOrderSlider value]-1)
				awayViceCaptain = -1;
		}
	} else {
		if ([teamForDetailView isEqualToString:@"home"]) {
			if (homeCaptain == (int)[battingOrderSlider value]-1)
				homeCaptain = -1;
		} else {
			if (awayCaptain == (int)[battingOrderSlider value]-1)
				awayCaptain = -1;
		}
	}
}
- (IBAction)VCSlider:(id)sender {
	if (ViceCaptainSlider.on) {
		[CaptainSlider setOn:NO animated:YES];
		if ([teamForDetailView isEqualToString:@"home"]) {
			homeViceCaptain = (int)[battingOrderSlider value]-1;
			if (homeCaptain == (int)[battingOrderSlider value]-1)
				homeCaptain = -1;
		} else {
			awayViceCaptain = (int)[battingOrderSlider value]-1;
			if (awayCaptain == (int)[battingOrderSlider value]-1)
				awayCaptain = -1;
		}
	} else {
		if ([teamForDetailView isEqualToString:@"home"]) {
			if (homeViceCaptain == (int)[battingOrderSlider value]-1)
				homeViceCaptain = -1;
		} else {
			if (awayViceCaptain == (int)[battingOrderSlider value]-1)
				awayViceCaptain = -1;
		}
	}
}
- (IBAction)WKSlider:(id)sender {
	if (WicketKeeperSlider.on) {
		if ([teamForDetailView isEqualToString:@"home"])
			homeWicketKeeper = (int)[battingOrderSlider value]-1;
		else
			awayWicketKeeper = (int)[battingOrderSlider value]-1;
	} else {
		if ([teamForDetailView isEqualToString:@"home"]) {
			if (homeWicketKeeper == (int)[battingOrderSlider value]-1)
				homeWicketKeeper = -1;
		} else {
			if (awayWicketKeeper == (int)[battingOrderSlider value]-1)
				awayWicketKeeper = -1;
		}
	}
}

- (void) retrievePlayersInDatabase: (int) teamID{
    const char *dbpath = [writableDBPath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &cricketDB) == SQLITE_OK)
    {
        NSString *string = [NSString stringWithFormat: @"SELECT PlayerName FROM PLAYERS WHERE TeamID = %d", teamID];
		const char *stmt = [string UTF8String];
		sqlite3_prepare_v2(cricketDB, stmt, -1, &statement, NULL);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSLog(@"\nAccess worked");
            //Put players into away array
            NSString *nameString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            NSLog(@"Player : %@",nameString);
            [playersInDatabase addObject: nameString];
        }
        sqlite3_finalize(statement);
        sqlite3_close(cricketDB);
    } else {
        NSLog(@"\nCould not access DB");
    }
}

- (void) editPlayersInArray{
    
    if (teamForDetailView == @"home"){
        for (int i=0 ; i <[playersInDatabase count]; i++){
            for (int j=0 ; j <[homePlayersArray count]; j++){
                NSString *a = (NSString *) [playersInDatabase objectAtIndex:i];
                NSString *b = (NSString *) [homePlayersArray objectAtIndex:j];
                if ([a isEqualToString:b]){
                    [displayPlayers replaceObjectAtIndex:i withObject:@"Remove"];
                }
            }
        }
    }
    else if (teamForDetailView == @"away"){
        for (int i=0 ; i <[playersInDatabase count]; i++){
            for (int j=0 ; j <[awayPlayersArray count]; j++){
                NSString *a = (NSString *) [playersInDatabase objectAtIndex:i];
                NSString *b = (NSString *) [awayPlayersArray objectAtIndex:j];
                if ([a isEqualToString:b]){
                    NSLog(@"REMOVE adhs");
                    [displayPlayers replaceObjectAtIndex:i withObject:@"Remove"];
                }
            }
        }
    }
    
    //Remove the strings "remove' from array
    for (int i=0 ; i<[displayPlayers count]; i++){
        NSLog(@"%d",i);
        if([displayPlayers objectAtIndex:i] == @"Remove"){
            [displayPlayers removeObjectAtIndex:i];
            i--;
        }
    }
    
    //Hide click button if the array is empty
    int c = [displayPlayers count];
    if (c < 1) _storedPlayersClicked.hidden = true;
    else _storedPlayersClicked.hidden = false;
    
    
    if (teamForDetailView == @"home"){
        [displayPlayers addObject:[homePlayersArray objectAtIndex:rowForDetaiView]];
    }
    else if (teamForDetailView == @"away"){
        [displayPlayers addObject:[awayPlayersArray objectAtIndex:rowForDetaiView]];
    }
    
    
    NSLog(@"\n\n\n\n\n\ndisplayPlayers NEW%@\n\n\n\n\n\n",displayPlayers);


}

//Return teams in database and put into array
- (int)countPlayersInDatabase : (int) teamID{
    const char *dbpath = [writableDBPath UTF8String];
    sqlite3_stmt *statement;
    int count = 0;
    if (sqlite3_open(dbpath, &cricketDB) == SQLITE_OK)
    {
        NSString *string = [NSString stringWithFormat: @"SELECT COUNT(PlayerName) FROM Players WHERE TeamID = %d", teamID];
		const char *stmt = [string UTF8String];
		sqlite3_prepare_v2(cricketDB, stmt, -1, &statement, NULL);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSLog(@"\nAccess worked");
            //Put players into away array
            count = sqlite3_column_int(statement, 0);
        }
        sqlite3_finalize(statement);
        sqlite3_close(cricketDB);
    } else {
        NSLog(@"\nCould not access DB");
    }
    return count;
}

- (void)viewDidLoad
{
    int c;
    
    playerInt = 0;
    
    //Initialise the array to hold teams
    playersInDatabase = [[NSMutableArray alloc] init];
    
    //Fill database!
    if(teamForDetailView == @"home"){
        [self retrievePlayersInDatabase : homeTeamID];
    }
    else if(teamForDetailView == @"away"){
        [self retrievePlayersInDatabase : awayTeamID];
    }
    
    //Count number of players in database
    c = [playersInDatabase count];
    if (c < 1) _storedPlayersClicked.hidden = true;
    else _storedPlayersClicked.hidden = false;
    
    //Make the display players array equal to the playersInDatabase array
    displayPlayers = [[NSMutableArray alloc] initWithArray:playersInDatabase copyItems:YES];
    
    if(teamForDetailView == @"home"){
        c = [self countPlayersInDatabase: homeTeamID];
    }
    else if(teamForDetailView == @"away"){
        c = [self countPlayersInDatabase: awayTeamID];
    }
    
    if (c < 1){
        _storedPlayersClicked.hidden = true;
    }
    else{
        _storedPlayersClicked.hidden = false;
    }
    
    //Edit display players array
    [self editPlayersInArray];

    [super viewDidLoad];
	// Do any additional setup after loading the view.
	NavBar.title = [arrayForDetailView objectAtIndex:rowForDetaiView];
	[battingOrderSlider setMaximumValue:([arrayForDetailView count]+0.9)];
	if (rowForDetaiView == 0){
		[previousPlayerButton setEnabled:NO];
	} else {
		[previousPlayerButton setEnabled:YES];
	}
	if (rowForDetaiView == [arrayForDetailView count]-1){
		[nextPlayerButton setEnabled:NO];
	} else {
		[nextPlayerButton setEnabled:YES];
	}
	if(disableElements){
		[_playerEditTextBox setEnabled:NO];
		[CaptainSlider setEnabled:NO];
		[ViceCaptainSlider setEnabled:NO];
		[WicketKeeperSlider setEnabled:NO];
		[battingOrderSlider setEnabled:NO];
		[bottomToolbar setHidden:YES];
	}
}

- (void)viewDidUnload
{
	[self setPlayerEditTextBox:nil];
	[self setNavBar:nil];
	[self setCaptainSlider:nil];
	[self setViceCaptainSlider:nil];
	[self setWicketKeeperSlider:nil];
	[self setBattingOrderSlider:nil];
	[self setSliderValueLabel:nil];
	[self setNextPlayerButton:nil];
	[self setPreviousPlayerButton:nil];
	[self setBottomToolbar:nil];
    [self setStoredPlayersClicked:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
