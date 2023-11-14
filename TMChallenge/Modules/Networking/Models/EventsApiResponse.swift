//
//  EventsApiResponse.swift
//  TMChallenge
//
//  Created by Francisco Jose Cordoba Rojas on 13/11/23.
//

import Foundation

// MARK: - EventsApiResponse
public struct EventsApiResponse: Codable {
    let embedded: EmbeddedApiResponse
    let page: PageApiResponse
    // let links: LinksApiResponse

    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
        case page
        // case links = "_links"
    }
}

// MARK: - Embedded
public struct EmbeddedApiResponse: Codable {
    let events: [EventApiResponse]
}

// MARK: - Event
public struct EventApiResponse: Codable {
    let name: String
    let id: String
    let test: Bool
    let url: String
    let images: [ImageApiResponse]
//    let locale: Locale
    //    let type: EventTypeApiResponse
//    let sales: SalesApiResponse
//    let dates: DatesApiResponse
//    let classifications: [ClassificationApiResponse]
//    let promoter: PromoterApiResponse?
//    let promoters: [PromoterApiResponse]?
//    let info, pleaseNote: String?
//    let priceRanges: [PriceRangeApiResponse]?
//    let products: [ProductApiResponse]?
//    let seatmap: SeatmapApiResponse
//    let accessibility: AccessibilityApiResponse?
//    let ticketLimit: TicketLimitApiResponse?
//    let ageRestrictions: AgeRestrictionsApiResponse?
//    let ticketing: TicketingApiResponse
//    let links: EventLinksApiResponse
//    let embedded: EventEmbeddedApiResponse
//    let outlets: [OutletApiResponse]?

    enum CodingKeys: String, CodingKey {
        case name, id, test, url, images // , sales, dates, classifications //type, locale, promoter, promoters, info, pleaseNote, priceRanges, products, seatmap, accessibility, ticketLimit, ageRestrictions, ticketing
//        case links = "_links"
//        case embedded = "_embedded"
//        case outlets
    }
}

// MARK: - Accessibility
struct AccessibilityApiResponse: Codable {
    let ticketLimit: Int
    let info: String?
}

// MARK: - AgeRestrictions
struct AgeRestrictionsApiResponse: Codable {
    let legalAgeEnforced: Bool
}

// MARK: - Classification
struct ClassificationApiResponse: Codable {
    let primary: Bool
    let segment, genre, subGenre: GenreApiResponse
    let type, subType: GenreApiResponse?
    let family: Bool
}

// MARK: - Genre
struct GenreApiResponse: Codable {
    let id: String
    let name: GenreNameApiResponse
}

enum GenreNameApiResponse: String, Codable {
    case allOfUS = "All of US"
    case basketball = "Basketball"
    case charlotte = "Charlotte"
    case group = "Group"
    case indianapolisAndMore = "Indianapolis and More"
    case miscellaneous = "Miscellaneous"
    case nCaliforniaNNevada = "N. California/N. Nevada"
    case nba = "NBA"
    case oklahoma = "Oklahoma"
    case parking = "Parking"
    case phoenixAndTucson = "Phoenix and Tucson"
    case portlandAndMore = "Portland and More"
    case regular = "Regular"
    case sanAntonioAndAustin = "San Antonio and Austin"
    case southCarolina = "South Carolina"
    case southTexas = "South Texas"
    case sports = "Sports"
    case team = "Team"
    case undefined = "Undefined"
}

// MARK: - Dates
struct DatesApiResponse: Codable {
    let start: StartApiResponse
    let timezone: String?
    let status: StatusApiResponse
    let spanMultipleDays: Bool
}

// MARK: - Start
struct StartApiResponse: Codable {
    let localDate, localTime: String
    let dateTime: Date
    let dateTBD, dateTBA, timeTBA, noSpecificTime: Bool
}

// MARK: - Status
struct StatusApiResponse: Codable {
    let code: CodeApiResponse
}

enum CodeApiResponse: String, Codable {
    case offsale = "offsale"
    case onsale = "onsale"
}

// MARK: - EventEmbedded
struct EventEmbedded: Codable {
    let venues: [VenueApiResponse]
    let attractions: [AttractionApiResponse]
}

// MARK: - Attraction
struct AttractionApiResponse: Codable {
    let name: String
    let type: AttractionTypeApiResponse
    let id: String
    let test: Bool
    let url: String
    let locale: LocaleApiResponse
    let externalLinks: ExternalLinksApiResponse
    let aliases: [String]?
    let images: [ImageApiResponse]
    let classifications: [ClassificationApiResponse]
    let upcomingEvents: UpcomingEventsApiResponse
    let links: AttractionLinksApiResponse

    enum CodingKeys: String, CodingKey {
        case name, type, id, test, url, locale, externalLinks, aliases, images, classifications, upcomingEvents
        case links = "_links"
    }
}

// MARK: - ExternalLinks
struct ExternalLinksApiResponse: Codable {
    let twitter, wiki, facebook, instagram: [FacebookApiResponse]
    let homepage: [FacebookApiResponse]
}

// MARK: - Facebook
struct FacebookApiResponse: Codable {
    let url: String
}

// MARK: - Image
public struct ImageApiResponse: Codable {
    let ratio: RatioApiResponse
    let url: String
    let width, height: Int
    let fallback: Bool
}

enum RatioApiResponse: String, Codable {
    case the16_9 = "16_9"
    case the3_2 = "3_2"
    case the4_3 = "4_3"
}

// MARK: - AttractionLinks
struct AttractionLinksApiResponse: Codable {
    let linksSelf: FirstApiResponse

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}

// MARK: - First
struct FirstApiResponse: Codable {
    let href: String
}

enum LocaleApiResponse: String, Codable {
    case enUs = "en-us"
}

enum AttractionTypeApiResponse: String, Codable {
    case attraction = "attraction"
}

// MARK: - UpcomingEvents
struct UpcomingEventsApiResponse: Codable {
    let tmr, ticketmaster: Int?
    let total, filtered: Int

    enum CodingKeys: String, CodingKey {
        case tmr, ticketmaster
        case total = "_total"
        case filtered = "_filtered"
    }
}

// MARK: - Venue
struct VenueApiResponse: Codable {
    let name: String
    let type: VenueTypeApiResponse
    let id: String
    let test: Bool
    let url: String?
    let locale: LocaleApiResponse
    let images: [ImageApiResponse]?
    let postalCode, timezone: String
    let city: CityApiResponse
    let state: StateApiResponse
    let country: CountryApiResponse
    let address: AddressApiResponse
    let location: LocationApiResponse
    let markets: [GenreApiResponse]?
    let dmas: [DMAApiResponse]
    let boxOfficeInfo: BoxOfficeInfoApiResponse?
    let parkingDetail, accessibleSeatingDetail: String?
    let generalInfo: GeneralInfoApiResponse?
    let upcomingEvents: UpcomingEventsApiResponse
    let links: AttractionLinksApiResponse
    let aliases: [String]?
    let social: SocialApiResponse?
    let ada: AdaApiResponse?

    enum CodingKeys: String, CodingKey {
        case name, type, id, test, url, locale, images, postalCode, timezone, city, state, country, address, location, markets, dmas, boxOfficeInfo, parkingDetail, accessibleSeatingDetail, generalInfo, upcomingEvents
        case links = "_links"
        case aliases, social, ada
    }
}

// MARK: - Ada
struct AdaApiResponse: Codable {
    let adaPhones, adaCustomCopy, adaHours: String
}

// MARK: - Address
struct AddressApiResponse: Codable {
    let line1: String
}

// MARK: - BoxOfficeInfo
struct BoxOfficeInfoApiResponse: Codable {
    let phoneNumberDetail, openHoursDetail, acceptedPaymentDetail: String
    let willCallDetail: String?
}

// MARK: - City
struct CityApiResponse: Codable {
    let name: String
}

// MARK: - Country
struct CountryApiResponse: Codable {
    let name: CountryNameApiResponse
    let countryCode: CountryCodeApiResponse
}

enum CountryCodeApiResponse: String, Codable {
    case us = "US"
}

enum CountryNameApiResponse: String, Codable {
    case unitedStatesOfAmerica = "United States Of America"
}

// MARK: - DMA
struct DMAApiResponse: Codable {
    let id: Int
}

// MARK: - GeneralInfo
struct GeneralInfoApiResponse: Codable {
    let generalRule, childRule: String
}

// MARK: - Location
struct LocationApiResponse: Codable {
    let longitude, latitude: String
}

// MARK: - Social
struct SocialApiResponse: Codable {
    let twitter: TwitterApiResponse
}

// MARK: - Twitter
struct TwitterApiResponse: Codable {
    let handle: String
}

// MARK: - State
struct StateApiResponse: Codable {
    let name, stateCode: String
}

enum VenueTypeApiResponse: String, Codable {
    case venue = "venue"
}

// MARK: - EventLinks
struct EventLinksApiResponse: Codable {
    let linksSelf: FirstApiResponse
    let attractions, venues: [FirstApiResponse]

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case attractions, venues
    }
}

// MARK: - Outlet
struct OutletApiResponse: Codable {
    let url: String
    let type: String
}

// MARK: - PriceRange
struct PriceRangeApiResponse: Codable {
    let type: PriceRangeTypeApiResponse
    let currency: CurrencyApiResponse
    let min, max: Int
}

enum CurrencyApiResponse: String, Codable {
    case usd = "USD"
}

enum PriceRangeTypeApiResponse: String, Codable {
    case standard = "standard"
}

// MARK: - Product
struct ProductApiResponse: Codable {
    let name, id: String
    let url: String
    let type: ProductTypeApiResponse
    let classifications: [ClassificationApiResponse]
}

enum ProductTypeApiResponse: String, Codable {
    case parking = "Parking"
    case upsell = "Upsell"
}

// MARK: - Promoter
struct PromoterApiResponse: Codable {
    let id: String
    let name: PromoterNameApiResponse
    let description: DescriptionApiResponse
}

enum DescriptionApiResponse: String, Codable {
    case nbaRegularSeasonNtlUsa = "NBA REGULAR SEASON / NTL / USA"
}

enum PromoterNameApiResponse: String, Codable {
    case nbaRegularSeason = "NBA REGULAR SEASON"
}

// MARK: - Sales
struct SalesApiResponse: Codable {
    let salesPublic: PublicApiResponse
    let presales: [PresaleApiResponse]?

    enum CodingKeys: String, CodingKey {
        case salesPublic = "public"
        case presales
    }
}

// MARK: - Presale
struct PresaleApiResponse: Codable {
    let startDateTime, endDateTime: Date
    let name: String
}

// MARK: - Public
struct PublicApiResponse: Codable {
    let startDateTime: Date
    let startTBD, startTBA: Bool
    let endDateTime: Date
}

// MARK: - Seatmap
struct SeatmapApiResponse: Codable {
    let staticURL: String

    enum CodingKeys: String, CodingKey {
        case staticURL = "staticUrl"
    }
}

// MARK: - TicketLimit
struct TicketLimitApiResponse: Codable {
    let info: String
}

// MARK: - Ticketing
struct TicketingApiResponse: Codable {
    let safeTix: AllInclusivePricingApiResponse?
    let allInclusivePricing: AllInclusivePricingApiResponse
}

// MARK: - AllInclusivePricing
struct AllInclusivePricingApiResponse: Codable {
    let enabled: Bool
}

enum EventTypeApiResponse: String, Codable {
    case event = "event"
}

// MARK: - Links
struct LinksApiResponse: Codable {
    let first, prev, linksSelf, next: FirstApiResponse
    let last: FirstApiResponse

    enum CodingKeys: String, CodingKey {
        case first, prev
        case linksSelf = "self"
        case next, last
    }
}

// MARK: - Page
public struct PageApiResponse: Codable {
    let size, totalElements, totalPages, number: Int
}
