//
//  SagePayVC.m
//  SagePaySample
//
//  Created by Pawan on 28/03/18.
//  Copyright © 2018 Pawan. All rights reserved.
//

#import "SagePayVC.h"
#import "SagePayConfig.h"
#import "NSData+Base64.h"
#import "SagePaySuccessOrFailVC.h"

@interface SagePayVC ()<UIWebViewDelegate>
{
    NSString *webLoadString;
    NSString *base64Key;
    NSString *dataString;
    
    BOOL successURLChecked;
    BOOL failureURLChecked;
}

@property(weak,nonatomic) IBOutlet UIWebView *webView;
@property(weak,nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(weak,nonatomic) IBOutlet UILabel *loadingLabel;
@property(weak,nonatomic) IBOutlet UIView *loadingView;

@end

@implementation SagePayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     webLoadString = @"";
     base64Key = @"";
     dataString = @"";
    
     successURLChecked = FALSE;
     failureURLChecked = FALSE;
    
    //Show Loader
    self.activityIndicator.hidden = FALSE;
    self.loadingLabel.hidden = FALSE;
    self.loadingView.hidden = FALSE;
    [self.activityIndicator startAnimating];
    
    [self retriveSAGEPAYMENT];
}

-(void)retriveSAGEPAYMENT{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [prefs objectForKey:@"BILLINGADDRESS"];
    NSDictionary *dictionary = (NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    if (dictionary) {
        
        NSLog(@"BILLINGADDRESS dictionary --->%@",dictionary);
        
        NSString *amountPayble = dictionary[@"amount"];
        NSString *countryName = dictionary[@"countryName"];
        NSString *countryCode = dictionary[@"countryCode"];
        NSString *mobileCode = dictionary[@"mobileCode"];
        NSString *mobileNumber = dictionary[@"mobileNumber"];
        NSString *fullName = dictionary[@"fullName"];
        NSString *email = dictionary[@"email"];
        NSString *address1 = dictionary[@"address1"];
        NSString *address2 = dictionary[@"address2"];
        NSString *city = dictionary[@"city"];
        NSString *state = dictionary[@"state"];
        NSString *postalCode = dictionary[@"postalCode"];
        
        NSArray *fullNameArr = [fullName componentsSeparatedByString:@" "];
        NSString *firstName  = fullNameArr[0];
        NSString *lastName  = fullNameArr.count > 1 ? fullNameArr[1] : fullNameArr[0];
        
        NSString *billingCityState = [NSString stringWithFormat:@"%@ %@",city,state];
        
        NSString *deliveryAddress = [NSString stringWithFormat:@"%@ %@",address1,address2];
        
        NSString *billingPhoneNumber = [NSString stringWithFormat:@"%@ %@",mobileCode,mobileNumber];

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
    }
}

- (NSString*)encodeStringTo64:(NSString*)fromString
{
    NSData *plainData = [fromString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String;
    if ([plainData respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        base64String = [plainData base64EncodedStringWithOptions:kNilOptions];  // iOS 7+
    } else {
        base64String = [plainData base64Encoding];                              // pre iOS7
    }
    
    return base64String;
}

-(NSString *) randomStringWithLength: (int) len {
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}

//encryption

- (NSData *)crypt:(NSData *)dataIn iv:(NSData *)iv key:(NSData *)symmetricKey context:(CCOperation)encryptOrDecrypt
{
    CCCryptorStatus ccStatus   = kCCSuccess;
    size_t          cryptBytes = 0;    // Number of bytes moved to buffer.
    NSMutableData  *dataOut    = [NSMutableData dataWithLength:dataIn.length + kCCBlockSizeAES128];
    
    ccStatus = CCCrypt( encryptOrDecrypt,
                       kCCAlgorithmAES128,
                       kCCOptionPKCS7Padding,
                       symmetricKey.bytes,
                       kCCKeySizeAES128,
                       iv.bytes,
                       dataIn.bytes,
                       dataIn.length,
                       dataOut.mutableBytes,
                       dataOut.length,
                       &cryptBytes);
    
    if (ccStatus != kCCSuccess) {
        NSLog(@"CCCrypt status: %d", ccStatus);
    }
    dataOut.length = cryptBytes;
    
    return dataOut;
}

- (void)webViewLoadByURL:(UIButton *)sender {
    
    NSURL *url = [NSURL URLWithString:webLoadString];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    self.webView.delegate = self;
    [self.webView loadRequest:requestObj];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlString = [[request URL] absoluteString];
    NSLog(@"Contents: %@",urlString);//Logout
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
     [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    //Hide Loader
    self.activityIndicator.hidden = TRUE;
    self.loadingLabel.hidden = TRUE;
    self.loadingView.hidden = TRUE;
    [self.activityIndicator stopAnimating];
    
    NSString *urlString = [[NSString alloc]initWithFormat:@"%@",webView.request.URL];
    
    NSLog(@"urlString-->%@",urlString);
    
    NSString *successURL = [SagePayConfig shared].sagePay_SuccessURL;
    NSString *failureURL = [SagePayConfig shared].sagePay_FailureURL;
    
    if ( [urlString rangeOfString:successURL].location != NSNotFound ) {
        // do something if the string is found
        NSLog(@"string contain successURL");
        
        if (successURLChecked == FALSE) {
        
            NSString *successString = [self decryptedResponseSepratedByCrypt:urlString];
            NSString *successdecodedString = [self decryptedDataWithResponse:successString];
            NSDictionary *successdecodedStringResponse = [self convertToDictionaryManually:successdecodedString];
            
            //Save Data
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:successdecodedStringResponse];
            [prefs setObject:myEncodedObject forKey:@"SAGEPAYMENT"];
            // This is suggested to synch prefs, but is not needed (I didn't put it in my tut)
            [prefs synchronize];
            
            NSString *status = successdecodedStringResponse[@"Status"];
            if ([status isEqualToString:@"OK"]) {
                
                //First Time Setup
                successURLChecked  = TRUE;
                failureURLChecked  = FALSE;
                
                [self gotoPaymentSuccessVC];
                
            }
            
        }
        
    } else if( [urlString rangeOfString:failureURL].location != NSNotFound ){
        // do something if the string is found
        NSLog(@"string contain failureURL");
        
        if (failureURLChecked == FALSE) {
            
            NSString *failureString = [self decryptedResponseSepratedByCrypt:urlString];
            NSString *failuredecodedString = [self decryptedDataWithResponse:failureString];
            NSDictionary *failuredecodedStringResponse = [self convertToDictionaryManually:failuredecodedString];
            
            //Save Data
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:failuredecodedStringResponse];
            [prefs setObject:myEncodedObject forKey:@"SAGEPAYMENT"];
            // This is suggested to synch prefs, but is not needed (I didn't put it in my tut)
            [prefs synchronize];
            
            /* OK ABORT REJECTED
             
             if status == "OK" || status == "NOTAUTHED" || status == "MALFORMED" || status == "INVALID" || status == "ABORT" || status == "REJECTED"  || status == "AUTHENTICATED" || status == "ERROR"
             */
            
            NSString *status = failuredecodedStringResponse[@"Status"];
            
            if ([status isEqualToString:@"OK"] || [status isEqualToString:@"NOTAUTHED"] ||[status isEqualToString:@"MALFORMED"] ||[status isEqualToString:@"INVALID"] ||[status isEqualToString:@"ABORT"] ||[status isEqualToString:@"REJECTED"] ||[status isEqualToString:@"AUTHENTICATED"] ||[status isEqualToString:@"ERROR"]) {
                
                //First Time Setup
                successURLChecked  = FALSE;
                failureURLChecked  = TRUE;
                
                [self gotoPaymentFailVC];
            }
        }
        
    }else {
        NSLog(@"string does not contain URL");
    }
    
    //  NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    // NSLog(@"html str:%@",html);
}

-(NSString *)decryptedResponseSepratedByCrypt:(NSString*)text {
    
    NSString *randomString = @"";
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"@"];
    NSArray * seprater = [text componentsSeparatedByCharactersInSet:characterSet];
    randomString = seprater[1];
    return randomString;
}

-(NSString *) decryptedDataWithResponse:(NSString*)text{
    
    NSString *decodedString = @"";
    
    NSData *key = [[NSData alloc] initWithBase64Encoding:base64Key];
    
    NSData *dataRecived = [self CreateDataWithHexString:text];
    NSData *decryptedData = [NSData crypt:dataRecived iv:key key:key context:kCCDecrypt];
    decodedString = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    return decodedString;
}


//I got the code to convert String to HEX-String in objective-C.

- (NSData *) CreateDataWithHexString:(NSString*)inputString
{
    NSUInteger inLength = [inputString length];
    
    
    unichar *inCharacters = alloca(sizeof(unichar) * inLength);
    [inputString getCharacters:inCharacters range:NSMakeRange(0, inLength)];
    
    UInt8 *outBytes = malloc(sizeof(UInt8) * ((inLength / 2) + 1));
    
    NSInteger i, o = 0;
    UInt8 outByte = 0;
    
    for (i = 0; i < inLength; i++) {
        UInt8 c = inCharacters[i];
        SInt8 value = -1;
        
        if      (c >= '0' && c <= '9') value =      (c - '0');
        else if (c >= 'A' && c <= 'F') value = 10 + (c - 'A');
        else if (c >= 'a' && c <= 'f') value = 10 + (c - 'a');
        
        if (value >= 0) {
            if (i % 2 == 1) {
                outBytes[o++] = (outByte << 4) | value;
                outByte = 0;
            } else {
                outByte = value;
            }
            
        } else {
            if (o != 0) break;
        }
    }
    
    NSData *a = [[NSData alloc] initWithBytesNoCopy:outBytes length:o freeWhenDone:YES];
    //NSString* newStr = [NSString stringWithUTF8String:[a bytes]];
    return a;
    
}

-(NSDictionary*) convertToDictionaryManually:(NSString*)text{
    
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"&"];
    NSArray * seprater = [text componentsSeparatedByCharactersInSet:characterSet];
    //print(seprater)
    
    // Initialize the Dictionary
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    
    for (NSString *keyStrin in seprater) {
        
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"="];
        NSArray * seprater = [keyStrin componentsSeparatedByCharactersInSet:characterSet];
        NSLog(@"%@",seprater);
        
        dictionary[seprater[0]] = seprater[1];
    }
    
    NSLog(@"dictionary--->%@",dictionary);
    
    return dictionary;
}

-(void)gotoPaymentSuccessVC{
    
    //SagePaySuccessOrFailVC
    SagePaySuccessOrFailVC *sagePaySuccessOrFailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SagePaySuccessOrFailVC"];
    [self.navigationController pushViewController:sagePaySuccessOrFailVC animated:YES];
    
}

-(void)gotoPaymentFailVC{
 
    //SagePaySuccessOrFailVC
    SagePaySuccessOrFailVC *sagePaySuccessOrFailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SagePaySuccessOrFailVC"];
    [self.navigationController pushViewController:sagePaySuccessOrFailVC animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
