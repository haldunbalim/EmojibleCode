//
//  OpenCVWrapper.m
//  EmojibleIOS
//
//  Created by Haldun Balim on 23.12.2020.
//

#import "OpenCVWrapper.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>


using namespace cv;
using namespace std;

@implementation OpenCVWrapper

+ (NSMutableArray *)extractRois:(UIImage*)inputImage {
    Mat mat;
    UIImageToMat(inputImage, mat);
    
    
    Mat resized;
    cv:: resize(mat, resized, cv::Size(inputImage.size.width,inputImage.size.height));
    
    
    Mat grayImg;
    cv:: cvtColor(resized, grayImg, cv::COLOR_RGBA2GRAY);
    
    Mat blur;
    cv:: medianBlur(grayImg, blur, 5);

    
    Mat sharpen;
    Mat sharpenKernel = Mat(3,3,CV_32F,-1);
    sharpenKernel.at<Float32>(1,1) = 9;

    cv:: filter2D(blur, sharpen, -1, sharpenKernel);
     
     
    Mat thresholded;
    int thr = 50;
    
    cv::threshold(sharpen, thresholded, thr , 255, cv::THRESH_BINARY_INV);
    
    vector<vector<cv::Point>> contours;
    cv::findContours(thresholded, contours, cv::RETR_EXTERNAL, cv::CHAIN_APPROX_SIMPLE);
    
    double contourAreas[contours.size()];
    for(int i=0; i< contours.size(); i++){
        contourAreas[i] = cv::contourArea(contours.at(i));
    }
        
    std::sort(contourAreas, contourAreas+contours.size());
    int lessThenTen = 0;
    for(int i=0; i< contours.size(); i++){
        if (contourAreas[i] >10){
            lessThenTen = i;
            break;
        }
    }
    double medianArea = contourAreas[lessThenTen + (contours.size() - lessThenTen) /2];
    int avgVertexLen = std::ceil(std::sqrt(medianArea));
    
    double threshold_const = 0.5;
    NSMutableArray *rects = [[NSMutableArray alloc] init];
    
    vector<vector<cv::Point> > contoursPoly( contours.size() );

    for(int i=0; i< contours.size(); i++){
        if (contourAreas[i] > 10 && contourAreas[i] < medianArea*(1+threshold_const) &&
            contourAreas[i] > medianArea*(1-threshold_const)){
            
            approxPolyDP( contours[i], contoursPoly[i], 3, true );

            cv::Rect rect = cv::boundingRect(contours[i]);
            
            NSArray *rectCoords = [NSArray arrayWithObjects:
                                   [NSNumber numberWithInt:rect.x],
                                   [NSNumber numberWithInt:rect.y],
                                   [NSNumber numberWithInt:avgVertexLen],
                                   [NSNumber numberWithInt:avgVertexLen], nil];
            [rects addObject:rectCoords];
        }
    }
    
    return rects;

}

@end
