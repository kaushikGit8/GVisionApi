//
//This file is subject to the terms and conditions defined in
//file 'LICENSE.md', which is part of this source code package.

#import <UIKit/UIKit.h>

@interface ImagePickerViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UITextView *labelResults;
@property (weak, nonatomic) IBOutlet UITextView *faceResults;
@property (weak, nonatomic) IBOutlet UITextView *combineResult;
@property (strong, nonatomic) NSString *binaryImageData;
@property (strong, nonatomic) UIImage *image;
@end

