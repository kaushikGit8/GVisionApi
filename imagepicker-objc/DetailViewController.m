//
//  DetailViewController.m
//  imagepicker-objc
//
//  Created by Kaushik Jadhav on 21/09/16.
//  Copyright © 2016 Sara Robinson. All rights reserved.
//

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 1) {
        return  [ImageModel sharedInstance].faces.count;
    }else
        return  [ImageModel sharedInstance].nature.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCellCollectionViewCell *cell = (MyCellCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    if (indexPath.section == 1) {
    
        cell.imageView.image =  (UIImage*)[[ImageModel sharedInstance].faces objectAtIndex:indexPath.row];
        //[cell.contentView addSubview:[[UIImageView alloc] initWithImage:[[ImageModel sharedInstance].faces objectAtIndex:indexPath.row]]];
       cell.contentView.backgroundColor = [UIColor grayColor];
    }else {
        cell.imageView.image =  (UIImage*)[[ImageModel sharedInstance].nature objectAtIndex:indexPath.row];
         //[cell.contentView addSubview:[[UIImageView alloc] initWithImage:[[ImageModel sharedInstance].nature objectAtIndex:indexPath.row]]];
       cell.contentView.backgroundColor = [UIColor brownColor]; 
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
        label.text = @"Persons";
        }else
        label.text = @"Nature"; 
        
        label.textColor = [UIColor redColor];
        [headerView addSubview:label];
        headerView.backgroundColor = [UIColor yellowColor];
        reusableview = headerView;
    }
    
//    if (kind == UICollectionElementKindSectionFooter) {
//        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
//        label.text = @"Footer";
//        label.textColor = [UIColor redColor];
//        [footerview addSubview:label];
//        footerview.backgroundColor = [UIColor yellowColor];
//        reusableview = footerview;
//    }
    
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
