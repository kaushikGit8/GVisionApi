//
//This file is subject to the terms and conditions defined in
//file 'LICENSE.md', which is part of this source code package.

#import "ImagePickerViewController.h"
#import "ImageModel.h"
#import "QHSpeechSynthesizerQueue.h"

@interface ImagePickerViewController (){
    QHSpeechSynthesizerQueue *synthesizerQueue;
}
@end

@implementation ImagePickerViewController

- (IBAction)loadImageButtonTapped:(UIButton *)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = false;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentViewController:imagePicker animated:true completion:NULL];
    
}

- (void)imagePickerController:(UIImagePickerController *)imagePicker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *pickedImage = info[UIImagePickerControllerOriginalImage];
    _image = pickedImage;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.faceResults.hidden = true;
    self.labelResults.hidden = true;
    [self.spinner startAnimating];
    
    // Base64 encode the image and create the request
    NSString *binaryImageData = [self base64EncodeImage:pickedImage];
    [self createRequest:binaryImageData];
    [imagePicker dismissViewControllerAnimated:true completion:NULL];
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

- (void) createRequest: (NSString*)imageData {
    // Create our request URL

    NSString *urlString = @"https://vision.googleapis.com/v1/images:annotate?key=";
    //NSString *API_KEY = @"AIzaSyCWDe0spQxCF-qZ_PzEgAaOM4RwrDeFcOI";
    NSString *API_KEY = @"AIzaSyCKHF7Pw-XKdoPoYnE0lI7hf-TaqiP_tsY";
    
    NSString *requestString = [NSString stringWithFormat:@"%@%@", urlString, API_KEY];
    
    NSURL *url = [NSURL URLWithString: requestString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod: @"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request
     addValue:[[NSBundle mainBundle] bundleIdentifier]
     forHTTPHeaderField:@"X-Ios-Bundle-Identifier"];
    
    // Build our API request
    NSDictionary *paramsDictionary =
        @{@"requests":@[
            @{@"image":
                @{@"content":imageData},
             @"features":@[
                @{@"type":@"LABEL_DETECTION",
                  @"maxResults":@10},
                @{@"type":@"FACE_DETECTION",
                  @"maxResults":@10},
                @{@"type":@"TEXT_DETECTION",
                  @"maxResults":@2}]}]};//TEXT_DETECTION
    
    NSError *error;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:paramsDictionary options:0 error:&error];
    [request setHTTPBody: requestData];

    [self.spinner startAnimating];
    self.combineResult.text = @"Analyzing the image, please wait...";
    [synthesizerQueue readNext:self.combineResult.text withLanguage:@"en_US" andRate:0.5 andClearQueue:YES];
    // Run the request on a background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self runRequestOnBackgroundThread: request];
    });
}

- (void)runRequestOnBackgroundThread: (NSMutableURLRequest*) request {
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^ (NSData *data, NSURLResponse *response, NSError *error) {
        [self analyzeResults:data];
    }];
    [task resume];
}

- (void)analyzeResults: (NSData*)dataToParse {
    
    // Update UI on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSError *e = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:dataToParse options:kNilOptions error:&e];
        
        NSArray *responses = [json objectForKey:@"responses"];
        NSLog(@"%@", responses);
        NSDictionary *responseData = [responses objectAtIndex: 0];
        NSDictionary *errorObj = [json objectForKey:@"error"];
        
        [self.spinner stopAnimating];
        
        self.labelResults.hidden = true;
        self.faceResults.hidden = true;
        NSString *combinedString = [NSString new];
        
        // Check for errors
        if (errorObj) {
            NSString *errorString1 = @"Error code ";
            NSString *errorCode = [errorObj[@"code"] stringValue];
            NSString *errorString2 = @": ";
            NSString *errorMsg = errorObj[@"message"];
            self.combineResult.text = [NSString stringWithFormat:@"%@%@%@%@", errorString1, errorCode, errorString2, errorMsg];
            
            
        } else {
            
            //Get Text annoatations
            NSArray *textAnnotations = [responseData objectForKey:@"textAnnotations"];
            NSInteger numTextLabels = [textAnnotations count];
            NSString *textAnalysis =  [NSString new];
            if(numTextLabels > 0){
                NSString *prominentText = [[textAnnotations objectAtIndex:0] objectForKey:@"description"];
                textAnalysis = [NSString stringWithFormat:@"This image contains following text : \n%@\n\n",prominentText];
            }else{
                //No Text found
                textAnalysis = @"No text present in the image \n\n";
            }

            
            // Get label annotations
            NSDictionary *labelAnnotations = [responseData objectForKey:@"labelAnnotations"];
            NSInteger numLabels = [labelAnnotations count];
            NSMutableArray *labels = [[NSMutableArray alloc] init];
            NSString *labelResultsText = [NSString new];
            if (numLabels > 0) {
                labelResultsText = @"This image may contain : ";
                for (NSDictionary *label in labelAnnotations) {
                    NSString *labelString = [label objectForKey:@"description"];
                    [labels addObject:labelString];
                }
                for (NSString *label in labels) {
                    // if it's not the last item add a comma
                    if (labels[labels.count - 1] != label) {
                        NSString *commaString = [label stringByAppendingString:@", "];
                        labelResultsText = [labelResultsText stringByAppendingString:commaString];
                    } else {
                        labelResultsText = [labelResultsText stringByAppendingString:label];
                    }
                }
                //self.labelResults.text = labelResultsText;
                if ([labelResultsText containsString:@"waterfall"] || [labelResultsText containsString:@"lake"] || [labelResultsText containsString:@"tree"]) {
                    if (_imageView)
                        [[ImageModel sharedInstance].nature addObject:_image];
                }else{
                    if (_imageView)
                        [[ImageModel sharedInstance].others addObject:_image];
                }
                
                
            } else {
                self.labelResults.text = @"No Tags found\n\n";
            }

            
            // Get face annotations
            NSDictionary *faceAnnotations = [responseData objectForKey:@"faceAnnotations"];
            NSString *facialAnalysisString = [NSString new];
            if (faceAnnotations != NULL) {
                // Get number of faces detected
                NSInteger numPeopleDetected = [faceAnnotations count];
                NSString *peopleStr = [NSString stringWithFormat:@"%lu", (unsigned long)numPeopleDetected];
                NSString *faceStr1 = @"\n\nPeople detected: ";
                facialAnalysisString = [NSString stringWithFormat:@"%@%@", faceStr1, peopleStr];
                facialAnalysisString = [facialAnalysisString stringByAppendingString:@"\nSwipe left to open Gallery"];
                if (_imageView)
                [[ImageModel sharedInstance].faces addObject:_image];
                
            } else {
                facialAnalysisString = @"\n\nNo faces found. \nSwipe left to open Gallery";
            }
             combinedString = [NSString stringWithFormat:@"%@%@%@",textAnalysis,labelResultsText,facialAnalysisString];
            self.combineResult.text = combinedString;
            [synthesizerQueue readNext:combinedString withLanguage:@"en_US" andRate:0.4 andClearQueue:NO];
            

        }
       
    });
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)imagePicker {
    [imagePicker dismissViewControllerAnimated:true completion:NULL];
}


-(void)showAlertWithMsg:(NSString*)string{

    // use UIAlertController
    UIAlertController *alert= [UIAlertController
                               alertControllerWithTitle:@"Alert"
                               message:string
                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){ }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) { }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)leftGesture:(id)sender {
    
    if ([self.faceResults.text containsString:@"Gallery"])
    [self performSegueWithIdentifier:@"gallery" sender:self];
    
}
- (IBAction)rightGesture:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    synthesizerQueue = [[QHSpeechSynthesizerQueue alloc] init];
    synthesizerQueue.duckOthers = YES;
    synthesizerQueue.preDelay = 1.0;
    synthesizerQueue.postDelay = 1.0;
    self.spinner.hidesWhenStopped = true;
    
    if (_binaryImageData)
        [self createRequest:_binaryImageData];
}

-(void)viewDidDisappear:(BOOL)animated{
    [synthesizerQueue stop];
}

@end
