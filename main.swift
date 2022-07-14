//
//  main.swift
//  SwiftAGDS
//
//  Created by Yusuke Ishihara on 2022-07-14.
//

// https://stackoverflow.com/questions/27721418/getting-list-of-files-in-documents-folder
// https://stackoverflow.com/questions/26338640/in-swift-fileexistsatpath-path-string-isdirectory-isdirectory-unsafemutable

import Foundation

// test invocation -> replace the argument for your environment
let folderStructure = FolderStructure()
folderStructure.printFolders(for: "/Users/yusuke/Desktop/textbooks/test")

class FolderStructure {
    
    private var fileNumber = 0
    private var folderNumber = 0
    
    init() {}
    
    let paddingChar = "      "
    let branchChar1 = "│ "
    let branchChar2 = "└─ "
    let branchChar3 = "├─ "
    
    func printFolders(for rootPath: String) -> Void{
        print(rootPath)
        printFoldersHelper(for: rootPath, depth: 0)
        print()
        printTotalFileNumber()
        print()
    }
    
    private func incrementFileNumber() -> Void {
        self.fileNumber += 1
    }
    
    private func incrementFolferNumber() -> Void {
        self.folderNumber += 1
    }
    
    func getFileNumber() -> Int {
        return self.fileNumber
    }
    
    func getFolderNumber() -> Int {
        return self.folderNumber
    }
    
    func resetCounter() -> Void {
        self.folderNumber = 0
        self.fileNumber = 0
    }
    
    private func printTotalFileNumber() -> Void {
        print("\(getFolderNumber()) directories, \(getFileNumber()) files")
        resetCounter()
    }
    
    private func printFoldersHelper(for parentPath: String, depth: Int, padding: String = "") -> Void {
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(atPath: parentPath)
            
            for (index, url) in directoryContents.enumerated() {
                if depth > 0 {
                    print(branchChar1, terminator: "")
                }
                
                // manage number of file(folder)
                if !isDirectory(at: parentPath + "/" + url) {
                    incrementFileNumber()
                }
                
                // print "└─" for last element for a folder, otherwise print "├─"
                let branchCharacter = index==directoryContents.count-1 ? branchChar2 : branchChar3
                print(padding + branchCharacter + url)
                
                // recursive invocation
                if isDirectory(at: parentPath + "/" + url) {
                    incrementFolferNumber()
                    printFoldersHelper(for: parentPath + "/" + url, depth: depth+1, padding: padding + paddingChar)
                }
            }
        } catch {
            print(error)
        }
    }
    
    private func isDirectory(at path: String) -> Bool {
        var directoryExists: ObjCBool = ObjCBool(false)
        _ = FileManager.default.fileExists(
            atPath: path,
            isDirectory: UnsafeMutablePointer<ObjCBool>(
                mutating: withUnsafePointer(to: &directoryExists){ $0 }
            )
        )
        return directoryExists.boolValue
    }
}
