//
//  SettingsViewController.m
//  TipCalculator
//
//  Created by Deepak Somashekhara on 9/9/14.
//  Copyright (c) 2014 Deepak Somashekhara. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *roundTotalSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *percentageControl;

-(void)updateSettings;

- (IBAction)roundTotalValueChanged:(id)sender;
- (IBAction)percentagePrefChanged:(id)sender;

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Settings";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self updateSettings];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) updateSettings
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL roundTotal = [defaults boolForKey:@"round_total_amount"];
    NSInteger prefPercentageIndex = [defaults integerForKey:@"pref_tip_percentage_index"];
    
    [self.roundTotalSwitch setOn:roundTotal animated:YES];
    self.percentageControl.selectedSegmentIndex = prefPercentageIndex;
}

- (IBAction)roundTotalValueChanged:(id)sender {
    BOOL switchValue = [self.roundTotalSwitch isOn];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:switchValue forKey:@"round_total_amount"];
    [defaults synchronize];
}

- (IBAction)percentagePrefChanged:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:self.percentageControl.selectedSegmentIndex forKey:@"pref_tip_percentage_index"];
    [defaults synchronize];
}

@end
