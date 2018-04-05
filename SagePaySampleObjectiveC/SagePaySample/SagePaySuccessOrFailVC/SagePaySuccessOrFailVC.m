//
//  SagePaySuccessOrFailVC.m
//  SagePaySample
//
//  Created by Pawan on 04/04/18.
//  Copyright © 2018 Pawan. All rights reserved.
//

#import "SagePaySuccessOrFailVC.h"

@interface SagePaySuccessOrFailVC ()

@property(weak,nonatomic) IBOutlet UILabel *bookingStatusMainHeader;
@property(weak,nonatomic) IBOutlet UILabel *bookingSubHeading;
@property(weak,nonatomic) IBOutlet UILabel *pnrNumberOUtlet;

@property(weak,nonatomic) IBOutlet UIImageView *statusImageViewOUtlet;

@end

@implementation SagePaySuccessOrFailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Retrive Details
    [self retriveSAGEPAYMENT];
}

-(void)retriveSAGEPAYMENT{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [prefs objectForKey:@"SAGEPAYMENT"];
    NSDictionary *dictionary = (NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    if (dictionary) {
        
     NSLog(@"SAGEPAYMENT RECIVED --->%@",dictionary);
        
        NSString *Status = @"";
        NSString *Amount = @"";
        NSString *PostCodeResult = @"";
        NSString *DeclineCode = @"";
        NSString *VPSTxId = @"";
        NSString *GiftAid = @"";
        NSString *VendorTxCode = @"";
        NSString *TxAuthNo = @"";
        NSString *BankAuthCode = @"";
        NSString *AddressResult = @"";
        NSString *AVSCV2 = @"";
        NSString *DSecureStatus = @"";
        NSString *ExpiryDate = @"";
        NSString *CardType = @"";
        NSString *Last4Digits = @"";
        NSString *StatusDetail = @"";
        NSString *CV2Result = @"";
        
        if (dictionary[@"Status"] != nil) {
            
            Status = dictionary[@"Status"];
        }
        if (dictionary[@"Amount"] != nil) {
            
            Amount = dictionary[@"Amount"];
        }
        if (dictionary[@"PostCodeResult"] != nil) {
            
            PostCodeResult = dictionary[@"PostCodeResult"];
        }
        if (dictionary[@"DeclineCode"] != nil) {
            
            DeclineCode = dictionary[@"DeclineCode"];
        }
        if (dictionary[@"VPSTxId"] != nil) {
            
            VPSTxId = dictionary[@"VPSTxId"];
        }
        if (dictionary[@"GiftAid"] != nil) {
            
            GiftAid = dictionary[@"GiftAid"];
        }
        if (dictionary[@"VendorTxCode"] != nil) {
            
            VendorTxCode = dictionary[@"VendorTxCode"];
        }
        if (dictionary[@"TxAuthNo"] != nil) {
            
            TxAuthNo = dictionary[@"TxAuthNo"];
        }
        if (dictionary[@"BankAuthCode"] != nil) {
            
            BankAuthCode = dictionary[@"BankAuthCode"];
        }
        if (dictionary[@"AddressResult"] != nil) {
            
            AddressResult = dictionary[@"AddressResult"];
        }
        if (dictionary[@"AVSCV2"] != nil) {
            
            AVSCV2 = dictionary[@"AVSCV2"];
        }
        if (dictionary[@"3DSecureStatus"] != nil) {
            
            DSecureStatus = dictionary[@"3DSecureStatus"];
        }
        if (dictionary[@"ExpiryDate"] != nil) {
            
            ExpiryDate = dictionary[@"ExpiryDate"];
        }
        if (dictionary[@"CardType"] != nil) {
            
            CardType = dictionary[@"CardType"];
        }
        if (dictionary[@"Last4Digits"] != nil) {
            
            Last4Digits = dictionary[@"Last4Digits"];
        }
        if (dictionary[@"StatusDetail"] != nil) {
            
            StatusDetail = dictionary[@"StatusDetail"];
        }
        if (dictionary[@"CV2Result"] != nil) {
            
            CV2Result = dictionary[@"CV2Result"];
        }
        
        //Booking Status Depand on "Status"
        //If Status
        
        NSString *bookingStatus = @"";
        
        if ([Status isEqualToString:@"OK"]){
            
            self.bookingStatusMainHeader.text = @"PAYMENT CONFIRMED";
            self.bookingStatusMainHeader.textColor = [UIColor whiteColor];
            self.bookingStatusMainHeader.backgroundColor = [UIColor greenColor];
            
            bookingStatus = [NSString stringWithFormat:@"Thank you for choosing SagePay, your payment is confirmed and reference number is - %@",VendorTxCode];
            
            [self.statusImageViewOUtlet setImage:[UIImage imageNamed:@"payment-success"]];

        }else{
            
            self.bookingStatusMainHeader.text = @"PAYMENT NOT CONFIRMED";
            self.bookingStatusMainHeader.textColor = [UIColor whiteColor];
            self.bookingStatusMainHeader.backgroundColor = [UIColor redColor];
            
            bookingStatus = [NSString stringWithFormat:@"Thank you for choosing SagePay, your payment is not confirmed and reference number is - %@",VendorTxCode];
            
            [self.statusImageViewOUtlet setImage:[UIImage imageNamed:@"payment-error"]];
                
                }
        
        //Show PNR Number
        self.pnrNumberOUtlet.text = VendorTxCode;
        
        self.bookingSubHeading.text = bookingStatus;
        
    }
}

-(IBAction)sagePaymentButtonTap:(id)sender{
   
      //Move To Home Screen
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
