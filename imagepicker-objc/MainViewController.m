//
//  MainViewController.m
//  imagepicker-objc
//
//  Created by Kaushik Jadhav on 27/09/16.
//  Copyright © 2016 Sara Robinson. All rights reserved.
//

#import "MainViewController.h"
#import "ImagePickerViewController.h"
#import "DetailViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController{

    NSString *binaryImageData;
    UIImage *pickedImage;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = false;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;

        [self presentViewController:imagePicker animated:true completion:NULL];
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


@end
