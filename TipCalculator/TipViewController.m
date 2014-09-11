//
//  TipViewController.m
//  TipCalculator
//
//  Created by Deepak Somashekhara on 9/8/14.
//  Copyright (c) 2014 Deepak Somashekhara. All rights reserved.
//

#import "TipViewController.h"
#import "SettingsViewController.h"

@interface TipViewController ()

@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;
@property (weak, nonatomic) IBOutlet UILabel *tipSubLabel;

@property (nonatomic) BOOL roundTotal;
@property (nonatomic) int prefPercentageIndex;

- (void)updateValues:(BOOL)overridePref;
- (void)onSettingsButton;
- (void)readPreferences;

- (IBAction)onTap:(id)sender;

@end

@implementation TipViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Tip Calculator";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self readPreferences];
    [self updateValues:NO];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsButton)];
    
    if ([self roundTotal])
    {
        self.tipSubLabel.text = @"(After adjustment)";
    }
    else
    {
        self.tipSubLabel.text = @"";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) readPreferences {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.roundTotal = [defaults boolForKey:@"round_total_amount"];
    self.prefPercentageIndex = [defaults integerForKey:@"pref_tip_percentage_index"];
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
    [self updateValues:NO];
}

- (void)updateValues:(BOOL)overridePref {
    float billAmount = [self.billTextField.text floatValue];
    NSArray* tipValues = @[@(0.1), @(0.15), @(0.2)];
    
    if(!overridePref)
    {
        self.tipControl.selectedSegmentIndex = [self prefPercentageIndex];
    }
    
    float tipAmount = billAmount * [tipValues[self.tipControl.selectedSegmentIndex] floatValue];
    float totalAmount = billAmount + tipAmount;
    
    if([self roundTotal])
    {
        float roundedTotal = roundf(totalAmount);
        float adjustment = totalAmount - roundedTotal;
        
        if( adjustment > 0.25 )
        {
            roundedTotal = roundedTotal + 0.5;
        }
        else if( adjustment < -0.25 )
        {
            roundedTotal = roundedTotal - 0.5;
        }
        
        //totalAmount = roundf(totalAmount);
        totalAmount = roundedTotal;
        
        // Adjust the tip if necessary after total amount is rounded off.
        tipAmount = totalAmount - billAmount;
    }
    
    self.tipLabel.text = [NSString stringWithFormat:@"%.2f", tipAmount];
    self.totalLabel.text = [NSString stringWithFormat:@"%.2f", totalAmount];
}

- (IBAction)onTipControlValueChange:(id)sender {
    [self updateValues:YES];
}

- (void) onSettingsButton {
    [self.navigationController pushViewController:[[SettingsViewController alloc] init] animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"view will appear");
    [self readPreferences];
    [self updateValues:NO];
    if ([self roundTotal])
    {
        self.tipSubLabel.text = @"(After adjustment)";
    }
    else
    {
        self.tipSubLabel.text = @"";
    }
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"view did appear");
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"view will disappear");
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"view did disappear");
}


@end
