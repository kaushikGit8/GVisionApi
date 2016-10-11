//
//  DetailViewController.m
//  Seed-GoogleCloudVision
//
//  Created by Krunal Soni on 21/09/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//
//
//This file is subject to the terms and conditions defined in
//file 'LICENSE.md', which is part of this source code package.

#import "DetailViewController.h"
#import "ImageModel.h"
#import "MyCellCollectionViewCell.h"
@interface DetailViewController ()

@end

@implementation DetailViewController

static NSString * const reuseIdentifier = @"cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}
- (IBAction)swipeGesture:(UISwipeGestureRecognizer *)sender {
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
         [self.navigationController popViewControllerAnimated:YES];
    }
   
     NSLog(@"Swipe detail");
}

- (IBAction)tapGesture:(UITapGestureRecognizer *)sender {
    
    
    NSLog(@"Tap detail");
}
#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 1) {
        return  [ImageModel sharedInstance].faces.count;
    }else if (section == 2){
        return  [ImageModel sharedInstance].nature.count;
    }else if (section == 3){
         return  [ImageModel sharedInstance].others.count;
    }
    return  0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCellCollectionViewCell *cell = (MyCellCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    if (indexPath.section == 1) {
       cell.imageView.image =  (UIImage*)[[ImageModel sharedInstance].faces objectAtIndex:indexPath.row];
       cell.contentView.backgroundColor = [UIColor clearColor];
    }else  if (indexPath.section == 2) {
       cell.imageView.image =  (UIImage*)[[ImageModel sharedInstance].nature objectAtIndex:indexPath.row];
       cell.contentView.backgroundColor = [UIColor clearColor];
    }
    else  if (indexPath.section == 3) {
        cell.imageView.image =  (UIImage*)[[ImageModel sharedInstance].others objectAtIndex:indexPath.row];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
        if (indexPath.section == 1) {
        label.text = @"  Persons :";
        }else if (indexPath.section == 2){
            label.text = @"  Nature :";
        }else if(indexPath.section == 3){
            label.text = @"  Others :";
        }
        
        label.textColor = [UIColor grayColor];
        [headerView addSubview:label];
        headerView.backgroundColor = [UIColor clearColor];
        reusableview = headerView;
    }
    return reusableview;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
