//
//  EventsTM.swift
//  TMChallenge
//
//  Created by Francisco Jose Cordoba Rojas on 13/11/23.
//

import Foundation

public final class EventsTM {
    let embedded: EmbeddedTM?
    let page: PageTM?
    
    init() {
        self.embedded = nil
        self.page = nil
    }
    
    init(embedded: EmbeddedApiResponse, page: PageApiResponse) {
        self.embedded = EmbeddedTM(apiResponse: embedded)
        self.page = PageTM(apiResponse: page)
    }
    
    public convenience init(apiResponse: EventsApiResponse) {
        self.init(embedded: apiResponse.embedded, page: apiResponse.page)
    }
}

public class EmbeddedTM {
    let events: [EventTM]
    
    init(events: [EventTM]) {
        self.events = events
    }
    
    public convenience init(apiResponse: EmbeddedApiResponse) {
        let newEvents: [EventTM] = apiResponse.events.map({ return EventTM(apiResponse: $0) })
        self.init(events: newEvents)
    }
}

public class EventTM {
    let name: String
    let id: String
    let test: Bool
    let url: String
    let images: [ImageTM]
    
    init(name: String, id: String, test: Bool, url: String, images: [ImageTM]) {
        self.name = name
        self.id = id
        self.test = test
        self.url = url
        self.images = images
    }
    
    convenience init(apiResponse: EventApiResponse) {
        let images = apiResponse.images.map { return ImageTM(apiResponse: $0) }
        self.init(name: apiResponse.name, id: apiResponse.id, test: apiResponse.test, url: apiResponse.url, images: images)
    }
}

public class ImageTM {
    let ratio: RatioTM
    let url: String
    let width, height: Int
    let fallback: Bool
    
    init(ratio: RatioTM, url: String, width: Int, height: Int, fallback: Bool) {
        self.ratio = ratio
        self.url = url
        self.width = width
        self.height = height
        self.fallback = fallback
    }
    
    public convenience init(apiResponse: ImageApiResponse) {
        var ratio: RatioTM
        switch apiResponse.ratio {
            case .the16_9: ratio = .the16_9
            case .the3_2: ratio = .the3_2
            case .the4_3: ratio = .the4_3
        }
        self.init(ratio: ratio, url: apiResponse.url, width: apiResponse.width, height: apiResponse.height, fallback: apiResponse.fallback)
    }
}

public enum RatioTM: String {
    case the16_9 = "16_9"
    case the3_2 = "3_2"
    case the4_3 = "4_3"
}

public class PageTM: Codable {
    let size, totalElements, totalPages, number: Int
    
    init(size: Int, totalElements: Int, totalPages: Int, number: Int) {
        self.size = size
        self.totalElements = totalElements
        self.totalPages = totalPages
        self.number = number
    }
    
    public convenience init(apiResponse: PageApiResponse) {
        self.init(size: apiResponse.size, totalElements: apiResponse.totalElements, totalPages: apiResponse.totalPages, number: apiResponse.number)
    }
}
