//
//  SagePayConfig.m
//  SagePaySample
//
//  Created by Pawan on 28/03/18.
//  Copyright © 2018 Pawan. All rights reserved.
//

#import "SagePayConfig.h"

@implementation SagePayConfig

+(SagePayConfig *)shared
{
    static dispatch_once_t once;
    static SagePayConfig * singleton;
    dispatch_once(&once, ^ { singleton = [[SagePayConfig alloc] init]; });
    return singleton;
}

//Init Singaltone class
- (id)init
{
    if (self = [super init]){
                
        //SagePayment credentials
        self.sagePay_TESTURL = @"https://test.sagepay.com/gateway/service/vspform-register.vsp";
        self.sagePay_LIVEURL = @"https://live.sagepay.com/gateway/service/vspform-register.vsp";
        self.sagePay_SuccessURL = @"https://pawankv89.github.io/SagePaySuccess/index.html";
        self.sagePay_FailureURL = @"https://pawankv89.github.io/SagePayFailed/index.html";
        self.sagePay_VendorEmail = @"gopalreddy2440@gmail.com";
        self.sagePay_VPSProtocol = @"3.00";
        self.sagePay_TxType  = @"DEFERRED";  //OR "PAYMENT"
        self.sagePay_Vendor  = @"protxross";
        self.sagePay_Password  = @"TPjs72eMz5qBnaTa";
        
        /*
         Visa Debit
         
         4900 0000 0000 0003
         03/2019  Current Month with Current Year
         123
         */
    }
    return self;
}


@end
