//
//  PaymentDetailsVC.m
//  SagePaySample
//
//  Created by Pawan on 28/03/18.
//  Copyright © 2018 Pawan. All rights reserved.
//

#import "PaymentDetailsVC.h"
#import "SagePayVC.h"

@interface PaymentDetailsVC ()

@property(weak,nonatomic) IBOutlet UILabel *amountLabel;
@property(weak,nonatomic) IBOutlet UILabel *firstnameLabel;
@property(weak,nonatomic) IBOutlet UILabel *surnameLabel;
@property(weak,nonatomic) IBOutlet UILabel *addressline1Label;
@property(weak,nonatomic) IBOutlet UILabel *addressline2Label;
@property(weak,nonatomic) IBOutlet UILabel *cityLabel;
@property(weak,nonatomic) IBOutlet UILabel *stateLabel;
@property(weak,nonatomic) IBOutlet UILabel *countryLabel;
@property(weak,nonatomic) IBOutlet UILabel *phonenumberLabel;
@property(weak,nonatomic) IBOutlet UILabel *emailLabel;
@property(weak,nonatomic) IBOutlet UILabel *pincodeLabel;

@end

@implementation PaymentDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.amountLabel.text = @"50.55";
    self.firstnameLabel.text = @"Pawan";
    self.surnameLabel.text = @"Sharma";
    self.addressline1Label.text = @"Sector 15";
    self.addressline2Label.text = @"Near PNB Bank";
    self.cityLabel.text = @"Noida";
    self.stateLabel.text = @"Uttar Pradesh";
    self.countryLabel.text = @"India";
    self.phonenumberLabel.text = @"9910xxxxxx";
    self.emailLabel.text = @"pawanxxxx@gmail.com";
    self.pincodeLabel.text = @"201301";
    
    // Initialize the Dictionary
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    
    dictionary[@"amount"] = self.amountLabel.text;
    dictionary[@"countryName"] = self.countryLabel.text;
    dictionary[@"countryCode"] = @"IN";
    dictionary[@"mobileCode"] = @"+91";
    dictionary[@"mobileNumber"] = self.phonenumberLabel.text;
    dictionary[@"fullName"] = [NSString stringWithFormat:@"%@ %@",self.firstnameLabel.text,self.surnameLabel.text];
    dictionary[@"email"] =  self.emailLabel.text;
    dictionary[@"address1"] =  self.addressline1Label.text;
    dictionary[@"address2"] =  self.addressline2Label.text; //Optional
    dictionary[@"city"] =  self.cityLabel.text;
    dictionary[@"state"] =  self.stateLabel.text;
    dictionary[@"postalCode"] = self.pincodeLabel.text;
    
    NSLog(@"BILLINGADDRESS SEND --->%@",dictionary);
    
    //Save Data
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
    [prefs setObject:myEncodedObject forKey:@"BILLINGADDRESS"];
    // This is suggested to synch prefs, but is not needed (I didn't put it in my tut)
    [prefs synchronize];
}

-(IBAction)sagePaymentButtonTap:(id)sender{
    //SagePayVC
    SagePayVC *sagePayVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SagePayVC"];
    [self.navigationController pushViewController:sagePayVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
