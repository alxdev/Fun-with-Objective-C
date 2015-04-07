//
//  FunCode.m

#import "FunCode.h"

@implementation FunCode


//Way to upload an Amazon S3 file
- (void)usingAmazonS3{
    {
        //Amazon S3
        AWSS3TransferManagerUploadRequest *uploadRequest1;
        
        BFTask *task = [BFTask taskWithResult:nil];
        [[task continueWithBlock:^id(BFTask *task) {
            // Creates a test file in the temporary directory
            self.testFileURL1 = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:filename]];
            
            [dataToUpload writeToURL:self.testFileURL1 atomically:YES];
            
            return nil;
        }] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
            
            return nil;
        }];
        
        
        __weak typeof(self) weakSelf = self;
        
        uploadRequest1 = [AWSS3TransferManagerUploadRequest new];
        uploadRequest1.bucket = @"nameof-bucket";
        uploadRequest1.key = filename;
        uploadRequest1.body = self.testFileURL1;
        uploadRequest1.uploadProgress =  ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend){
            dispatch_sync(dispatch_get_main_queue(), ^{
                //weakSelf.file1AlreadyUpload = totalBytesSent;
                //[weakSelf updateProgress];
            });
        };
        
        
        AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
        
        [[transferManager upload:uploadRequest1] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
            if (task.error != nil) {
                if( task.error.code != AWSS3TransferManagerErrorCancelled
                   &&
                   task.error.code != AWSS3TransferManagerErrorPaused
                   )
                {
                    NSLog(@"error: %@",task.error);
                }

            } else {
                NSLog(@"Uploaded!");
                
                WebService *webService = [[WebService alloc]init];
                [webService changePhoto:self.user photo:filename];
                
            }
            return nil;
        }];
        
}
    
-(void)settingSizeOfScroll{

    int screenHeight = [[UIScreen mainScreen] applicationFrame].size.height;
    CGRect frame;
    CGFloat scrollBarHeight;
    
    frame = self.selfController.view.frame;
    if (frame.size.height < screenHeight) {
        frame.size.height = screenHeight;
        scrollBarHeight = frame.size.height+20;
    }else{
        scrollBarHeight = frame.size.height+frame.size.height-screenHeight+200;
    }
    self.view.frame = frame;
    
    [self.scrollView setContentSize:CGSizeMake(self.selfController.view.bounds.size.width,scrollBarHeight)];
    
}
    
    


@end
