//
//  UGPath.swift
//  Pods
//
//  Created by admin on 2021/7/2.
//

import Foundation

/// Home目录  ./
public let KHomeDirectory = NSHomeDirectory()

/// Documnets目录
public let KDocumentPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                        FileManager.SearchPathDomainMask.userDomainMask, true)
public let KDocumnetPath = KDocumentPaths[0]

/// Library目录
public let KLibraryPaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory,
                                                       FileManager.SearchPathDomainMask.userDomainMask, true)
public let KLibraryPath = KLibraryPaths[0]

/// Cache目录
public let KCachePaths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory,
                                                     FileManager.SearchPathDomainMask.userDomainMask, true)
public let KCachePath = KCachePaths[0]

/// tmp
public let KTmpDir = NSTemporaryDirectory()
