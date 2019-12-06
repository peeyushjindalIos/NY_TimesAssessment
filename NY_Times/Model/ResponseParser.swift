//
//  ResponseParser.swift
//  NY_Times
//
//  Created by kalyani satapathy on 06/12/19.
//  Copyright © 2019 Dalmia Best Price. All rights reserved.
//

import Foundation

class ResponseParser: NSObject {

    static let sharedInstance = ResponseParser()

    func apiResponse(jsonDic : NSDictionary) -> NSMutableArray {
        
        let returnArray = NSMutableArray()
        
        if let status = jsonDic.object(forKey: "status") as? NSString, status == "OK"{
            
            if let results = jsonDic.object(forKey: "results") as? NSArray{
                
                for result in results{
                    
                    var modelResult = Result()
                    
                    modelResult.abstractField = (result as! NSDictionary).object(forKey: "abstractField") as? String ?? ""
                    modelResult.assetId = (result as! NSDictionary).object(forKey: "assetId") as? Int ?? 0
                    modelResult.byline = (result as! NSDictionary).object(forKey: "byline")  as? String ?? ""
                    modelResult.column = (result as! NSDictionary).object(forKey: "column")  as? String ?? ""
                    modelResult.desFacet = (result as! NSDictionary).object(forKey: "desFacet")  as? [String] ?? []
                    modelResult.geoFacet = (result as! NSDictionary).object(forKey: "geoFacet") as? [String] ?? []
                    modelResult.perFacet = (result as! NSDictionary).object(forKey: "perFacet")  as? [String] ?? []
                    modelResult.section = (result as! NSDictionary).object(forKey: "section")  as? String ?? ""
                    modelResult.source = (result as! NSDictionary).object(forKey: "source")  as? String ?? ""
                    modelResult.title = (result as! NSDictionary).object(forKey: "title")  as? String ?? ""
                    modelResult.type = (result as! NSDictionary).object(forKey: "type")  as? String ?? ""
                    modelResult.publishedDate = (result as! NSDictionary).object(forKey: "published_date")  as? String ?? ""
                    modelResult.url = (result as! NSDictionary).object(forKey: "url")  as? String ?? ""
                    modelResult.views = (result as! NSDictionary).object(forKey: "views")  as? Int ?? 0
                    
                    if let media = (result as! NSDictionary).object(forKey: "media") as? NSArray{
                        
                        modelResult.media = [Media]()
                        
                        for result in media{
                            
                            var modelMedia = Media()
                            
                            modelMedia.caption = (result as! NSDictionary).object(forKey: "abstractField") as? String ?? ""
                            modelMedia.approvedForSyndication = (result as! NSDictionary).object(forKey: "assetId") as? Int ?? 0
                            modelMedia.subtype = (result as! NSDictionary).object(forKey: "byline")  as? String ?? ""
                            modelMedia.type = (result as! NSDictionary).object(forKey: "byline")  as? String ?? ""
                            
                            if let metadata = (result as! NSDictionary).object(forKey: "media-metadata") as? NSArray{
                                
                                modelMedia.mediaMetadata = [MediaMetadata]()
                                
                                for result in metadata{
                                    
                                    var modelMetaData = MediaMetadata()
                                    
                                    modelMetaData.url = (result as! NSDictionary).object(forKey: "url")  as? String ?? ""
                                    modelMetaData.format = (result as! NSDictionary).object(forKey: "format") as? String ?? ""
                                    modelMetaData.height = (result as! NSDictionary).object(forKey: "height") as? Int ?? 0
                                    modelMetaData.width = (result as! NSDictionary).object(forKey: "width")  as? Int ?? 0
                                    
                                    modelMedia.mediaMetadata.append(modelMetaData)
                                    
                                }
                                
                            }
                            
                            modelResult.media.append(modelMedia)
                        }
                        
                    }
                    returnArray.add(modelResult)
                    
                }
                
            }
            
        }
        
       return returnArray
    }
}
