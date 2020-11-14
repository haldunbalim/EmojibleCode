//
//  FileManager.swift
//  EmojibleIOS
//
//  Created by Haldun Balim on 14.11.2020.
//

import Foundation
class FileSystemManager{
    
    let fileManager = FileManager.default
    
    func deleteFile(filename: String) -> Bool{
        let path = getPath(filename: filename)
            
        do {
            try fileManager.removeItem(at: path)
        } catch  {
            return false
        }
        return true
    }
    
    func renameFile(previousFilename: String, newFilename:String) -> Bool{
        let previousFilePath = getPath(filename: previousFilename)
        let newFilePath = getPath(filename: newFilename)
            
        do {
            try fileManager.moveItem(at: previousFilePath, to: newFilePath)
        } catch  {
            return false
        }
        return true
    }
    
    func fileExists(filename:String) -> Bool{
        return fileManager.fileExists(atPath: getPath(filename: filename).path)
    }
    
    func getPath(filename: String) -> URL{
        return getDocumentsDirectory().appendingPathComponent(filename)
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private static var instance: FileSystemManager!
    
    public static func getInstance() -> FileSystemManager{
        if instance==nil{
            instance = FileSystemManager()
        }
        return instance
    }
}
