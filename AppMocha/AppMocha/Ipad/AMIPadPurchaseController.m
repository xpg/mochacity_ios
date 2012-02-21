//
//  AMIPadPurchaseController.m
//  AppMocha
//
//  Created by Jason Wang on 12/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AMIPadPurchaseController.h"

#import "AMIPadProductShowController.h"

#import "AMProductCell.h"
#import "AMDemoProduct.h"

#import "AMAppDelegate.h"

#import "AppBandKit.h"

@interface AMIPadPurchaseController()

@property(nonatomic,copy) NSArray *productArray;

- (void)getProductsEnd:(ABProductsResponse *)response;

- (NSString *)getDocumentPath;

@end

@implementation AMIPadPurchaseController

@synthesize productArray = _productArray;

- (void)getProductsEnd:(ABProductsResponse *)response {
    if (response.code == ABResponseCodeHTTPSuccess) {
        NSMutableArray *temArray = [NSMutableArray array];
        NSArray *products = response.products;
        for (ABProduct *product in products) {
            AMDemoProduct *amProduct = [AMDemoProduct productWithABProduct:product];
            [temArray addObject:amProduct];
        }
        self.productArray = [NSArray arrayWithArray:temArray];
        [productsTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }
}

- (NSString *)getDocumentPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 145;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AMDemoProduct *product = [self.productArray objectAtIndex:indexPath.row];
    
    if (product.isDownloading) return;
        
    if (product.isDownload && [(AMAppDelegate *)[UIApplication sharedApplication].delegate availableString:product.filePath]) {
        AMIPadProductShowController *showController = [[AMIPadProductShowController alloc] initWithNibName:@"AMIPadProductShowController" bundle:nil];
        [showController setImagePath:product.filePath];
        
        [self.navigationController pushViewController:showController animated:YES];
        
        [showController release];
    } else {
        [[ABPurchase shared] purchaseProduct:product.product notificationKey:[NSString stringWithFormat:@"%@%@",AppBand_App_Product_Prefix,product.product.productId] path:[self getDocumentPath]];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.productArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AMProductCell";
    AMProductCell *cell = (AMProductCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        [[NSBundle mainBundle] loadNibNamed:@"AMProductCell" owner:self options:NULL];
        cell = productCell;
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    AMDemoProduct *product = [self.productArray objectAtIndex:indexPath.row];
    
    [cell setDemoProduct:product];
    
    return cell;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.productArray = nil;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)dealloc {
    [self setProductArray:nil];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[ABPurchase shared] getAppProductByGroup:nil target:self finishSelector:@selector(getProductsEnd:)];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return YES;
}

@end
