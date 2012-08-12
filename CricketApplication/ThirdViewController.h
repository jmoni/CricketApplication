//
//  ThirdViewController.h
//  CricketApplication
//
//  Created by Lion User on 31/07/2012.
//  Copyright (c) 2012 JMoni. All rights reserved.
//

#import <UIKit/UIKit.h>

NSString *scoreString;

@interface ThirdViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *ball6;
@property (strong, nonatomic) IBOutlet UILabel *ball5;
@property (strong, nonatomic) IBOutlet UILabel *ball4;
@property (strong, nonatomic) IBOutlet UILabel *ball3;
@property (strong, nonatomic) IBOutlet UILabel *ball2;
@property (strong, nonatomic) IBOutlet UILabel *ball1;
@property (strong, nonatomic) IBOutlet UIImageView *batter1Active;
@property (strong, nonatomic) IBOutlet UIImageView *batter2Active;
@property (strong, nonatomic) IBOutlet UILabel *batter1BallsLabel;
@property (strong, nonatomic) IBOutlet UILabel *batter2BallsLabel;
@property (strong, nonatomic) IBOutlet UILabel *batter1RunsLabel;
@property (strong, nonatomic) IBOutlet UILabel *batter2RunsLabel;
@property (strong, nonatomic) IBOutlet UIButton *bowlerButton;
@property (strong, nonatomic) IBOutlet UILabel *oversLabel;
@property (strong, nonatomic) IBOutlet UILabel *maidensLabel;
@property (strong, nonatomic) IBOutlet UILabel *runsLabel;
@property (strong, nonatomic) IBOutlet UILabel *wicketsLabel;
@property (strong, nonatomic) IBOutlet UILabel *economyLabel;
@property (strong, nonatomic) IBOutlet UILabel *noBallLabel;
@property (strong, nonatomic) IBOutlet UILabel *wideLabel;
@property (strong, nonatomic) IBOutlet UILabel *byeLabel;
@property (strong, nonatomic) IBOutlet UILabel *legByeLabel;
@property (strong, nonatomic) IBOutlet UILabel *penLabel;
@property (strong, nonatomic) IBOutlet UILabel *totLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *calculatorView;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *ballLabels;
@property (strong, nonatomic) IBOutlet UIButton *startGameButton;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *ballsScrollView;
@property (strong, nonatomic) IBOutlet UIButton *nextOverButton;

-(IBAction)showActionSheet: (id) sender;
-(IBAction)hideActionSheet: (UIBarButtonItem *)_infoButtonItem;
-(IBAction)hideActionSheetB:(id)sender;
-(IBAction)showOutOptions:(id)sender;
-(IBAction)showExtrasOptions:(id)sender;
-(IBAction)noRuns:(id)sender;
-(IBAction)plusOne:(id)sender;
-(IBAction)four:(id)sender;
-(IBAction)six:(id)sender;
-(IBAction)confirm:(id)sender;
-(IBAction)undo:(id)sender;
-(IBAction)startGame:(id)sender;
-(IBAction)extraNoBall:(id)sender;
-(IBAction)extraWide:(id)sender;
-(IBAction)extraBye:(id)sender;
-(IBAction)extraLegBye:(id)sender;
-(IBAction)extraPen:(id)sender;
-(IBAction)byeCalc:(id)sender string:(NSString *)identifier;
-(IBAction)byePlusOne:(id)sender;
-(IBAction)fourBye:(id)sender;
-(IBAction)sixBye:(id)sender;
-(IBAction)addExtras:(id)sender;
-(IBAction)turnLabelsOrange:(id)sender;
-(IBAction)turnLabelsRed:(id)sender;
-(IBAction)turnLabelsGreen:(id)sender;
-(IBAction)turnLabelsBlack:(id)sender;
-(IBAction)updateExtrasLabels:(id)sender;
-(IBAction)nextOver:(id)sender;
-(IBAction)resetExtra:(id)sender;
@end