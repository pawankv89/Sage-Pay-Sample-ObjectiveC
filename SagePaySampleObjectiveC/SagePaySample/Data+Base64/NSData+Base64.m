//
//  NSData+Base64.m
//
// Derived from http://colloquy.info/project/browser/trunk/NSDataAdditions.h?rev=1576
// Created by khammond on Mon Oct 29 2001.
// Formatted by Timothy Hatcher on Sun Jul 4 2004.
// Copyright (c) 2001 Kyle Hammond. All rights reserved.
// Original development by Dave Winer.
//

#import "NSData+Base64.h"

#import <Foundation/Foundation.h>

@implementation NSData (Base64)

- (NSString *)hexadecimalString
{
    const unsigned char *dataBuffer = (const unsigned char *)[self bytes];
    if (!dataBuffer)
    {
        return [NSString string];
    }
    NSUInteger          dataLength  = [self length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for (int i = 0; i < dataLength; ++i)
    {
        [hexString appendFormat:@"%02x", (unsigned int)dataBuffer[i]];
    }
    return [NSString stringWithString:hexString];
}


+ (NSData *)crypt:(NSData *)dataIn iv:(NSData *)iv key:(NSData *)symmetricKey context:(CCOperation)encryptOrDecrypt
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



@end
