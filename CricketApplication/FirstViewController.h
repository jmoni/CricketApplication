//
//  FirstViewController.h
//  CricketApplication
//
//  Created by Rob Lloyd on 30/07/2012.
//  Copyright (c) 2012 JMoni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController <UIActionSheetDelegate, UITextFieldDelegate, UIScrollViewDelegate>{
    UITextField *homeTeamEntered;
    UITextField *awayTeamEntered;
    IBOutlet UIDatePicker *datePicker;
}

@property (strong, nonatomic) IBOutlet UITextField *homeTeamEntered;
@property (strong, nonatomic) IBOutlet UITextField *awayTeamEntered;
@property (strong, nonatomic) IBOutlet UISlider *timeSlide;
@property (strong, nonatomic) IBOutlet UIButton *dateButton;
@property (strong, nonatomic) IBOutlet UILabel *dateText;
@property (strong, nonatomic) IBOutlet UISlider *overSlide;
@property (strong, nonatomic) IBOutlet UILabel *overTimeLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *switcher;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *infoButtonItem;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;



- (IBAction)showActionSheet: (id) sender;
- (IBAction)hideActionSheet: (UIBarButtonItem *)_infoButtonItem;
- (IBAction)textFieldReturn:(id)sender;
- (IBAction)changeDate: (id)sender;
- (IBAction)sliderUpdate: (id)sender;
- (IBAction)timeSliderUpdate: (id)sender;
- (IBAction)flipSwitch: (id)sender;
@end