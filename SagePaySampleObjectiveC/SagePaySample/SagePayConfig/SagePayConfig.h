//
//  SagePayConfig.h
//  SagePaySample
//
//  Created by Pawan on 28/03/18.
//  Copyright © 2018 Pawan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SagePayConfig : NSObject

+(SagePayConfig *)shared;

@property(strong,nonatomic)NSString *sagePay_TESTURL;
@property(strong,nonatomic)NSString *sagePay_LIVEURL;
@property(strong,nonatomic)NSString *sagePay_SuccessURL;
@property(strong,nonatomic)NSString *sagePay_FailureURL;
@property(strong,nonatomic)NSString *sagePay_VendorEmail;
@property(strong,nonatomic)NSString *sagePay_VPSProtocol;
@property(strong,nonatomic)NSString *sagePay_TxType;
@property(strong,nonatomic)NSString *sagePay_Vendor;
@property(strong,nonatomic)NSString *sagePay_Password;

@end
