//
//  AMDemoProduct.m
//  AppMocha
//
//  Created by Jason Wang on 12/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AMDemoProduct.h"

#import "AppBandKit.h"

@interface AMDemoProduct()

- (void)downloadProgress:(NSNotification *)notification;

@end

@implementation AMDemoProduct

@synthesize product;
@synthesize filePath;
@synthesize isDownload;
@synthesize icon;
@synthesize isDownloading;

- (void)downloadProgress:(NSNotification *)notification {
    ABPurchaseResponse *response = [notification object];
    
    switch (response.proccessStatus) {
        case ABPurchaseProccessStatusEnd: {
            switch (response.status) {
                case ABPurchaseStatusSuccess: {
                    [self setFilePath:response.filePath];
                    [self setIsDownload:YES];
                    [self setIsDownloading:NO];
                    break;
                }
                case ABPurchaseStatusDeliverFail: {
                    [self setFilePath:nil];
                    [self setIsDownload:NO];
                    [self setIsDownloading:NO];
                    break;
                }
                case ABPurchaseStatusDeliverCancelled: {
                    [self setFilePath:nil];
                    [self setIsDownload:NO];
                    [self setIsDownloading:NO];
                    break;
                }
                case ABPurchaseStatusDeliverURLFailure: {
                    [self setFilePath:nil];
                    [self setIsDownload:NO];
                    [self setIsDownloading:NO];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case ABPurchaseProccessStatusDoing: {
            switch (response.status) {
                case ABPurchaseStatusDeliverBegan: {
                    [self setIsDownload:NO];
                    [self setIsDownloading:YES];
                    break;
                }
                default:
                    break;
            }
            break;
        }
    }
}

+ (AMDemoProduct *)productWithABProduct:(ABProduct *)pro {
    AMDemoProduct *p = [[[AMDemoProduct alloc] init] autorelease];
    [p setProduct:pro];
    [p setFilePath:nil];
    [p setIcon:nil];
    [p setIsDownload:NO];
    [p setIsDownloading:NO];
    
    NSString *nKey = [NSString stringWithFormat:@"%@%@",AppBand_App_Product_Prefix,pro.productId];
    [[NSNotificationCenter defaultCenter] addObserver:p selector:@selector(downloadProgress:) name:nKey object:nil];
    
    return p;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setProduct:nil];
    [self setFilePath:nil];
    [self setIcon:nil];
    [super dealloc];
}

@end
