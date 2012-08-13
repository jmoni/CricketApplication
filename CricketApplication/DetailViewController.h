//
//  DetailViewController.h
//  CricketApplication
//
//  Created by Rob Lloyd on 31/07/2012.
//  Copyright (c) 2012 JMoni. All rights reserved.
//

#import <UIKit/UIKit.h>

NSMutableArray *playersInDatabase;
NSMutableArray *displayPlayers;

@interface DetailViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UITextField *playerEditTextBox;
@property (strong, nonatomic) IBOutlet UISlider *battingOrderSlider;
@property (strong, nonatomic) IBOutlet UILabel *sliderValueLabel;
@property (strong, nonatomic) IBOutlet UINavigationItem *NavBar;
@property (strong, nonatomic) IBOutlet UISwitch *CaptainSlider;
@property (strong, nonatomic) IBOutlet UISwitch *ViceCaptainSlider;
@property (strong, nonatomic) IBOutlet UISwitch *WicketKeeperSlider;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *nextPlayerButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *previousPlayerButton;
@property (strong, nonatomic) IBOutlet UIToolbar *bottomToolbar;
@property (strong, nonatomic) IBOutlet UIButton *storedPlayersClicked;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *infoButtonItem;
@property (strong, nonatomic) IBOutlet UIPickerView * choosePlayer;

- (IBAction)textFieldReturn:(id)sender;
- (IBAction)backgroundTouched:(id)sender;
- (IBAction)battingOrderSliderChanged:(id)sender;
- (IBAction)battingOrderSliderChanging:(id)sender;
- (IBAction)getInitialSlideValue:(id)sender;
- (IBAction)CSlider:(id)sender;
- (IBAction)VCSlider:(id)sender;
- (IBAction)WKSlider:(id)sender;
- (IBAction)deletePlayer:(id)sender;
- (IBAction)nextPlayer:(id)sender;
- (IBAction)previousPlayer:(id)sender;
- (IBAction)storedPlayersAction:(id)sender;
@end