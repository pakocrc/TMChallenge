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

public class EventTM: Identifiable, Hashable {
    public let name: String?
    public let id: String?
    public let test: Bool?
    public let url: String?
    public let images: [ImageTM]?
    public let dates: DatesTM?
//    public let eventLinks: EventLinksTMy
    public let eventEmbedded: EventEmbeddedTM?
    
    init(name: String?, id: String?, test: Bool?, url: String?, images: [ImageTM]?, dates: DatesTM?, /*eventLinks: EventLinksTM,*/ eventEmbedded: EventEmbeddedTM?) {
        self.name = name
        self.id = id
        self.test = test
        self.url = url
        self.images = images
        self.dates = dates
//        self.eventLinks = eventLinks
        self.eventEmbedded = eventEmbedded
    }
    
    convenience init(apiResponse: EventApiResponse) {
        let images = apiResponse.images?.map { ImageTM(apiResponse: $0) }
        self.init(name: apiResponse.name,
                  id: apiResponse.id, 
                  test: apiResponse.test,
                  url: apiResponse.url,
                  images: images,
                  dates: DatesTM(apiResponse: apiResponse.dates),
//                  eventLinks: EventLinksTM(apiResponse: apiResponse.eventLinks),
                  eventEmbedded: EventEmbeddedTM(apiResponse: apiResponse.eventEmbedded))
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }

    public static func == (lhs: EventTM, rhs: EventTM) -> Bool {
        return lhs.id == rhs.id
    }
}

public class EventEmbeddedTM {
    let venues: [VenueTM]?
    
    init(venues: [VenueTM]?) {
        self.venues = venues
    }
    
    convenience init(apiResponse: EventEmbeddedApiResponse?) {
        let venues = apiResponse?.venues.map({ VenueTM(apiResponse: $0) })
        self.init(venues: venues)
    }
}

public class VenueTM {
    let name: String?
    let id: String?
    let test: Bool?
    let url: String?
    let city: PlaceTM?
    let state: PlaceTM?
    let country: PlaceTM?
    let address: PlaceTM?
    
    init(name: String?, id: String?, test: Bool?, url: String?, city: PlaceTM?, state: PlaceTM?, country: PlaceTM?, address: PlaceTM?) {
        self.name = name
        self.id = id
        self.test = test
        self.url = url
        self.city = city
        self.state = state
        self.country = country
        self.address = address
    }
    
    convenience init(apiResponse: VenueApiResponse) {
        self.init(name: apiResponse.name, 
                  id: apiResponse.id,
                  test: apiResponse.test,
                  url: apiResponse.url,
                  city: PlaceTM(name: apiResponse.city?.name),
                  state: PlaceTM(name: apiResponse.state?.name),
                  country: PlaceTM(name: apiResponse.country?.name),
                  address: PlaceTM(name: apiResponse.address?.line1))
    }
}

public class PlaceTM {
    let name: String?
    
    init(name: String?) {
        self.name = name
    }
}

public class EventLinksTM {
    let linksSelf: FirstTM
    let attractions, venues: [FirstTM]

    init(linksSelf: FirstTM, attractions: [FirstTM], venues: [FirstTM]) {
        self.linksSelf = linksSelf
        self.attractions = attractions
        self.venues = venues
    }
    
    convenience init(apiResponse: EventLinksApiResponse) {
        let attractions = apiResponse.attractions.map({ FirstTM(href: $0.href) })
        let venues = apiResponse.venues.map({ FirstTM(href: $0.href) })
        
        self.init(linksSelf: FirstTM(apiResponse: apiResponse.linksSelf),
                  attractions: attractions,
                  venues: venues)
    }
}

public class FirstTM {
    public let href: String
    
    init(href: String) {
        self.href = href
    }
    
    convenience init(apiResponse: FirstApiResponse) {
        self.init(href: apiResponse.href)
    }
}

public class ImageTM {
    public let ratio: RatioTM?
    public let url: String?
    public let width, height: Int?
    public let fallback: Bool?
    
    init(ratio: RatioTM?, url: String?, width: Int?, height: Int?, fallback: Bool?) {
        self.ratio = ratio
        self.url = url
        self.width = width
        self.height = height
        self.fallback = fallback
    }
    
    public convenience init(apiResponse: ImageApiResponse?) {
        var ratio: RatioTM
        switch apiResponse?.ratio {
            case .the16_9: ratio = .the16_9
            case .the3_2: ratio = .the3_2
            case .the4_3: ratio = .the4_3
            default: ratio = .the4_3
        }
        self.init(ratio: ratio, url: apiResponse?.url, width: apiResponse?.width, height: apiResponse?.height, fallback: apiResponse?.fallback)
    }
}

public enum RatioTM: String {
    case the16_9 = "16_9"
    case the3_2 = "3_2"
    case the4_3 = "4_3"
}

public class DatesTM {
    let start: StartTM?
    let timezone: String?
    let status: StatusTM?
    let spanMultipleDays: Bool?
    
    init(start: StartTM?, timezone: String?, status: StatusTM?, spanMultipleDays: Bool?) {
        self.start = start
        self.timezone = timezone
        self.status = status
        self.spanMultipleDays = spanMultipleDays
    }
    
    convenience init(apiResponse: DatesApiResponse?) {
        self.init(start: StartTM(apiResponse: apiResponse?.start),
                  timezone: apiResponse?.timezone,
                  status: StatusTM(apiResponse: apiResponse?.status),
                  spanMultipleDays: apiResponse?.spanMultipleDays)
    }
}

// MARK: - Start
public class StartTM {
    let localDate, localTime, dateTime: String?
//    let dateTime: Date
    let dateTBD, dateTBA, timeTBA, noSpecificTime: Bool?
    
    init(localDate: String?, localTime: String?, dateTime: String?, dateTBD: Bool?, dateTBA: Bool?, timeTBA: Bool?, noSpecificTime: Bool?) {
        self.localDate = localDate
        self.localTime = localTime
        self.dateTime = dateTime
        self.dateTBD = dateTBD
        self.dateTBA = dateTBA
        self.timeTBA = timeTBA
        self.noSpecificTime = noSpecificTime
    }
    
    convenience init(apiResponse: StartApiResponse?) {
        self.init(localDate: apiResponse?.localDate, localTime: apiResponse?.localDate, dateTime: apiResponse?.dateTime, dateTBD: apiResponse?.dateTBD, dateTBA: apiResponse?.dateTBA, timeTBA: apiResponse?.timeTBA, noSpecificTime: apiResponse?.noSpecificTime)
    }
}

// MARK: - Status
public class StatusTM {
    let code: CodeTM?
    
    init(code: CodeTM) {
        self.code = code
    }
    
    convenience init(apiResponse: StatusApiResponse?) {
        var code: CodeTM
        switch apiResponse?.code {
            case .offsale: code = .offsale
            case .onsale: code = .onsale
            default: code = .offsale
        }
        self.init(code: code)
    }
}

enum CodeTM: String, Codable {
    case offsale = "offsale"
    case onsale = "onsale"
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
