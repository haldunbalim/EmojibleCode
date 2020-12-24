//
//  VisionModel.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 23.12.2020.
//

import Foundation
import UIKit
import CoreML

fileprivate let modelOutputClasses=["Plus","NumericUserInput","Red","RGen","For",
                                    "ShakeSensor","SoundLevel","Apple","If","AssignmentEmoji",
                                    "Banana","Parrot","Equals","Multiplication","Greater",
                                    "Touched","Playprerecordedspeech","Blue","Minus","LBracket",
                                    "Smaller","BabyChick","SpeechBubble","Flipped","False",
                                    "Comment","True","LightSensor","Screen","RBracket",
                                    "While","Comma","Green","Division"]
class VisionModel{
    
    private init(){
    }
    
    
    private func resize(img:UIImage, lowDim:Int = 1024) -> UIImage{
        let width = Float(img.size.width)
        let height = Float(img.size.height)
        if ( width < height){
            let apScaled = Int(height/width*Float(lowDim))
            return img.resized(to: CGSize(width: lowDim, height: apScaled))
        }else{
            let apScaled = Int(width/height*Float(lowDim))
            return img.resized(to: CGSize(width: apScaled, height: lowDim))
        }
    }
    
    
    private func extractRois(img:UIImage) ->[[Int]]{
        return OpenCVWrapper.extractRois(img) as! [[Int]]
    }
    
    private func extractStringPos(coords:[[Int]], newLineHeightConstant:Double = 0.7) -> [[[Int]]]{
        var meanHeight:Double = 0
        for coord in coords{
            meanHeight += Double(coord[3])
        }
        meanHeight /= Double(coords.count)
        
        let ySortedCoords = coords.sorted{$0[1] < $1[1]}
        var lines = [[ySortedCoords[0]]]
        
        for idx in 1 ..< ySortedCoords.count{
            let rect = ySortedCoords[idx]
            if rect[1] > lines[lines.count-1][0][1] + Int(meanHeight * newLineHeightConstant){
                lines.append([rect])
            }else{
                lines[lines.count-1].append(rect)
            }
        }
        
        var linesXsorted: [[[Int]]] = []
        
        for line in lines{
            if line.count == 1{
                linesXsorted.append(line)
            }else{
                linesXsorted.append(line.sorted{$0[0]<$1[0]})
            }
        }
        
        return linesXsorted
        
    }
    
    private func predictEmojis(lines: [[[Int]]], image: UIImage) -> String{
        var str = ""
        for line in lines{
            var strLine = ""
            for coords in line{
                let roi = image.cropped(rect: CGRect(x: coords[0], y: coords[1], width: coords[2], height: coords[3]))
                
                let resizedRoi = roi!.resized(to:  CGSize(width: 64, height:64))
                
                let pred = predict(img: resizedRoi)
                strLine += pred + " "
            }
            str += strLine + "\n"
        }
        return str
    }
    
    private func predict(img: UIImage) -> String{
        let model = emoji_resnet()
        let preds = try? model.prediction(input: emoji_resnetInput(input_16: preprocess(image: img,width: 64,height: 64)!))
        guard let id = preds?.Identity else { return ""}
        
        var amax = 0
        var max:Float32 = 0
        
        for i in 0 ..< id.count{
            if Float32(id[i]) > max{
                amax = i
                max = Float32(id[i])
            }
        }
        return modelOutputClasses[amax]
        
    }
    
    private func preprocess(image: UIImage, width: Int, height: Int) -> MLMultiArray? {
        guard let pixels = image.pngData()?.map({ (Double($0) / 255.0) }) else {
            return nil
        }

        guard let array = try? MLMultiArray(shape: [1, height, width, 3] as [NSNumber], dataType: .double) else {
            return nil
        }

        let r = pixels.enumerated().filter { $0.offset % 4 == 0 }.map { $0.element }
        let g = pixels.enumerated().filter { $0.offset % 4 == 1 }.map { $0.element }
        let b = pixels.enumerated().filter { $0.offset % 4 == 2 }.map { $0.element }

        let combination = r + g + b
        for (index, element) in combination.enumerated() {
            array[index] = NSNumber(value: element)
        }

        return array
    }
    
    public func imageToEmojiString(img: UIImage) -> String{
        let resizedImg = resize(img: img)
        
        let coords = extractRois(img: resizedImg)
        let lines = extractStringPos(coords: coords)
        return predictEmojis(lines:lines, image: img)
    }
    
    
    private static let instance = VisionModel()
    public static func getInstance() -> VisionModel{
        return .instance
    }
}
