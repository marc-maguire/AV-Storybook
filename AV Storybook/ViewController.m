//
//  ViewController.m
//  AV Storybook
//
//  Created by Marc Maguire on 2017-05-19.
//  Copyright © 2017 Marc Maguire. All rights reserved.
//

#import "ViewController.h"
#import "AVData.h"
@import AVFoundation;

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic) AVData *audioVisualData;


@property (nonatomic) AVAudioRecorder *recorder;
@property (nonatomic) AVAudioPlayer *player;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic) UITapGestureRecognizer *tapper;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.audioVisualData = [[AVData alloc]init];
    self.image.userInteractionEnabled = YES;
    self.tapper = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toggleAudioPlayback:)];
    [self.image addGestureRecognizer:self.tapper];

NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    // make the URL we will save/play from be a file called recording.m4a in that directory
self.audioVisualData.savedAudioFile = [NSURL fileURLWithPath:[docsDir stringByAppendingPathComponent:@"recording.m4a"]];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Get the app's document directory
    
}
- (IBAction)imagePicker:(UIButton *)sender {
}
- (IBAction)toggleRecord:(UIButton *)sender {
    
    
    if (self.recorder.recording) {
        [sender setTitle:@"Record" forState:UIControlStateNormal];
        [self.recorder stop];
    } else {
        NSError *error;
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
        
        self.recorder = [[AVAudioRecorder alloc]initWithURL:self.audioVisualData.savedAudioFile
                                                   settings:@{AVFormatIDKey: @(kAudioFormatMPEG4AAC),
                                                              AVSampleRateKey: @(44100),
                                                              AVNumberOfChannelsKey: @(2)}
                                                      error:&error];
        if (error != nil) {
            NSLog(@"Could not create player %@",error.localizedDescription);
        }
        [self.recorder record];
        
    }
   
}
- (IBAction)toggleAudioPlayback:(UITapGestureRecognizer *)sender {
    if (self.player.playing) {
        NSLog(@"in toggle playback");
        [self.player stop];
    } else {
        NSError *error;
        self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:self.audioVisualData.savedAudioFile error:&error];
        
        if (error != nil){
            NSLog(@"Could not initiate player %@", error.localizedDescription);
            NSLog(@"starting to play playback");
           
        }
         [self.player play];
    }


}

- (IBAction)pickImage:(id)sender {
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    //init the vc
    //set the source type
    //get the available media types based on your source type
    //set the media types
    //assign the delegate of the imagepicker to self
    //present the image picker
    

//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//  
//        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
//    } else {
//     
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    }
    

    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:ipc.sourceType];
    NSLog(@"Media types are %@", availableMediaTypes);
    ipc.mediaTypes = availableMediaTypes;
   
    ipc.delegate = self;
    
    [self presentViewController:ipc animated:YES completion:^{
        NSLog(@"Picker is showing");
    }];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"Finished picking %@", info);
    self.image.image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"done");
    }];
}

@end
