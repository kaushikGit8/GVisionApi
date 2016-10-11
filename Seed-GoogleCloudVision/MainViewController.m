//
//  MainViewController.m
//  Seed-GoogleCloudVision
//
//  Created by Krunal Soni on 27/09/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//
//
//This file is subject to the terms and conditions defined in
//file 'LICENSE.md', which is part of this source code package.

#import "MainViewController.h"
#import "ImagePickerViewController.h"
#import "DetailViewController.h"
#import "TGCameraViewController.h"
#import "QHSpeechSynthesizerQueue.h"

@interface MainViewController ()<TGCameraDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tapToTakeImage;
@property (weak, nonatomic) IBOutlet UILabel *swipeToGallery;

@end

@implementation MainViewController{

    NSString *binaryImageData;
    UIImage *pickedImage;
    QHSpeechSynthesizerQueue *synthesizerQueue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Text to Speech
    synthesizerQueue = [[QHSpeechSynthesizerQueue alloc] init];
    synthesizerQueue.duckOthers = YES;
    synthesizerQueue.preDelay = 1.0;
    synthesizerQueue.postDelay = 1.0;
   
    
    // Setting Camera properties
    [TGCamera setOption:kTGCameraOptionHiddenFilterButton value:[NSNumber numberWithBool:YES]];
    [TGCamera setOption:kTGCameraOptionSaveImageToAlbum value:[NSNumber numberWithBool:YES]];
    [TGCamera setOption:kTGCameraOptionHiddenToggleButton value:[NSNumber numberWithBool:YES]];
}


-(void)viewWillAppear:(BOOL)animated{
    [synthesizerQueue readImmediately:_tapToTakeImage.text withLanguage:@"en_US" andRate:0.5 andClearQueue:NO];
    [synthesizerQueue readNext:_swipeToGallery.text withLanguage:@"en_US" andRate:0.5 andClearQueue:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [synthesizerQueue stop];
}

- (IBAction)swipeGesture:(UISwipeGestureRecognizer *)sender {
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
    NSLog(@"Swipe ..left");
      
        [self performSegueWithIdentifier:@"detail" sender:self];

    }
    
}

- (IBAction)tapGesture:(UITapGestureRecognizer *)sender {
    
    if (sender.numberOfTapsRequired == 1)
    {
        NSLog(@"Tap Gesture.. ");
        
        TGCameraNavigationController *navigationController =
        [TGCameraNavigationController newWithCameraDelegate:self];
        
        [self presentViewController:navigationController animated:YES completion:nil];
        
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)imagePicker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *pickedImageData = info[UIImagePickerControllerOriginalImage];
    pickedImage = pickedImageData;
    // Base64 encode the image and create the request
    binaryImageData = [self base64EncodeImage:pickedImage];
    [imagePicker dismissViewControllerAnimated:true completion:NULL];
    
    [self performSegueWithIdentifier:@"capture" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"capture"]) {
        
        ImagePickerViewController *controller = (ImagePickerViewController*)segue.destinationViewController;
        controller.binaryImageData = binaryImageData;
        controller.image = pickedImage;
    }
}


- (UIImage *) resizeImage: (UIImage*) image toSize: (CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (NSString *) base64EncodeImage: (UIImage*)image {
    NSData *imagedata = UIImagePNGRepresentation(image);
    
    // Resize the image if it exceeds the 2MB API limit
    if ([imagedata length] > 2097152) {
        CGSize oldSize = [image size];
        CGSize newSize = CGSizeMake(800, oldSize.height / oldSize.width * 800);
        image = [self resizeImage: image toSize: newSize];
        imagedata = UIImagePNGRepresentation(image);
    }
    NSString *base64String = [imagedata base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    return base64String;
}

#pragma mark - TGCameraDelegate required

- (void)cameraDidCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cameraDidTakePhoto:(UIImage *)image
{
    UIImage *pickedImageData = image;
    pickedImage = pickedImageData;
    // Base64 encode the image and create the request
    binaryImageData = [self base64EncodeImage:pickedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"capture" sender:self];

}

- (void)cameraDidSelectAlbumPhoto:(UIImage *)image
{
    UIImage *pickedImageData = image;
    pickedImage = pickedImageData;
    // Base64 encode the image and create the request
    binaryImageData = [self base64EncodeImage:pickedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"capture" sender:self];
}

@end
