
SagePaySampleObjectiveC
=========

## SagePaySampleObjectiveC.
------------
 Added Some screens here.
 
 Visualization of SagePay Failed Page http://pawankv89.github.io/SagePayFailed/index.html
 Visualization of SagePay Success Page http://pawankv89.github.io/SagePaySuccess/index.html
 

[![](https://github.com/pawankv89/SagePaySampleObjectiveC/blob/master/Screens/1.png)]
[![](https://github.com/pawankv89/SagePaySampleObjectiveC/blob/master/Screens/2.png)]
[![](https://github.com/pawankv89/SagePaySampleObjectiveC/blob/master/Screens/3.png)]
[![](https://github.com/pawankv89/SagePaySampleObjectiveC/blob/master/Screens/4.png)]
[![](https://github.com/pawankv89/SagePaySampleObjectiveC/blob/master/Screens/5.png)]
[![](https://github.com/pawankv89/SagePaySampleObjectiveC/blob/master/Screens/6.png)]
[![](https://github.com/pawankv89/SagePaySampleObjectiveC/blob/master/Screens/7.png)]
[![](https://github.com/pawankv89/SagePaySampleObjectiveC/blob/master/Screens/8.png)]
[![](https://github.com/pawankv89/SagePaySampleObjectiveC/blob/master/Screens/9.png)]
[![](https://github.com/pawankv89/SagePaySampleObjectiveC/blob/master/Screens/10.png)]


## Usage
------------
 iOS 9 Demo showing how to Used SagePayment on iPhone X Simulator in  Objective-C.

```objective-c

Test Card Details
//Amex
//3742 0000 0000 004
//01/18
//1234

//SagePayment credentials
NSString *baseURL   = [SagePayConfig shared].sagePay_TESTURL;
NSString *vendorTxCode   = [self randomStringWithLength:16];
NSString *amount   = amountPayble;
NSString *currency   = @"GBP";
NSString *description   = @"Booking from iOS Product Name App";
NSString *surname   = lastName;
NSString *customerEMail   = email;
NSString *vendorEMail   = [SagePayConfig shared].sagePay_VendorEmail;
NSString *billingFirstnames   = firstName;
NSString *billingSurname   = lastName;
NSString *billingAddress1   = deliveryAddress;
NSString *billingCity   = billingCityState;
NSString *billingPostCode   = postalCode;
NSString *billingCountry   = countryCode;
NSString *billingPhone   = billingPhoneNumber;
NSString *deliveryFirstnames   = firstName;
NSString *deliverySurname   = lastName;
NSString *deliveryAddress1   = deliveryAddress;
NSString *deliveryCity   = billingCityState;
NSString *deliveryPostCode   = postalCode;
NSString *deliveryCountry   = countryCode;
NSString *deliveryPhone   = billingPhoneNumber;
NSString *successURL   = [SagePayConfig shared].sagePay_SuccessURL;
NSString *failureURL   = [SagePayConfig shared].sagePay_FailureURL;
//Other Params
NSString *VPSProtocol   = [SagePayConfig shared].sagePay_VPSProtocol;
NSString *TxType   = [SagePayConfig shared].sagePay_TxType;
NSString *Vendor   = [SagePayConfig shared].sagePay_Vendor;
//Convert Pass to base64 Key
NSString *sagePay_Password = [SagePayConfig shared].sagePay_Password;

base64Key = [self encodeStringTo64:sagePay_Password];
NSLog(@"base64Key: %@",base64Key);

//First Time Setup
successURLChecked  = FALSE;
failureURLChecked  = FALSE;

dataString = [NSString stringWithFormat:@"VendorTxCode=%@&Amount=%@&Currency=%@&Description=%@&Surname=%@&CustomerEMail=%@&VendorEMail=%@&BillingSurname=%@&BillingFirstnames=%@&BillingAddress1=%@&BillingCity=%@&BillingPostCode=%@&BillingCountry=%@&BillingPhone=%@&DeliveryFirstnames=%@&DeliverySurname=%@&DeliveryAddress1=%@&DeliveryCity=%@&DeliveryPostCode=%@&DeliveryCountry=%@&DeliveryPhone=%@&SuccessURL=%@&FailureURL=%@",vendorTxCode,amount,currency,description,surname,customerEMail,vendorEMail,billingSurname,billingFirstnames,billingAddress1,billingCity,billingPostCode,billingCountry,billingPhone,deliveryFirstnames,deliverySurname,deliveryAddress1,deliveryCity,deliveryPostCode,deliveryCountry,deliveryPhone,successURL,failureURL];

NSLog(@"Send Request: %@",dataString);

NSData *key  = [[NSData alloc] initWithBase64EncodedString:base64Key  options:0];
NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];

NSData *encryptedData = [self crypt:data
iv:key
key:key
context:kCCEncrypt];

NSString *hex111 = [encryptedData hexadecimalString];

webLoadString = [NSString stringWithFormat:@"%@?VPSProtocol=%@&TxType=%@&Vendor=%@&Crypt=@%@",baseURL,VPSProtocol,TxType,Vendor,[hex111 uppercaseString]];

//Load WebView by URL

[self webViewLoadByURL:webLoadString];

```

```objective-c

```

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).

## Change-log

A brief summary of each this release can be found in the [CHANGELOG](CHANGELOG.mdown). 
