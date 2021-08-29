import Foundation

// MARK: - GifData
struct GifData: Codable {
    let data: DataClass
    let meta: Meta
}

// MARK: - DataClass
struct DataClass: Codable {
    let type, id: String
    let url: String
    let slug: String
    let bitlyGIFURL, bitlyURL, embedURL: String
    let username, source, title, rating: String
    let contentURL, sourceTLD, sourcePostURL: String
    let isSticker: Int
    let importDatetime, trendingDatetime: String
    let images: Images
    let user: User
    let imageOriginalURL, imageURL: String
    let imageMp4URL: String
    let imageFrames, imageWidth, imageHeight: String
    let fixedHeightDownsampledURL: String
    let fixedHeightDownsampledWidth, fixedHeightDownsampledHeight: String
    let fixedWidthDownsampledURL: String
    let fixedWidthDownsampledWidth, fixedWidthDownsampledHeight: String
    let fixedHeightSmallURL, fixedHeightSmallStillURL: String
    let fixedHeightSmallWidth, fixedHeightSmallHeight: String
    let fixedWidthSmallURL, fixedWidthSmallStillURL: String
    let fixedWidthSmallWidth, fixedWidthSmallHeight, caption: String

    enum CodingKeys: String, CodingKey {
        case type, id, url, slug
        case bitlyGIFURL = "bitly_gif_url"
        case bitlyURL = "bitly_url"
        case embedURL = "embed_url"
        case username, source, title, rating
        case contentURL = "content_url"
        case sourceTLD = "source_tld"
        case sourcePostURL = "source_post_url"
        case isSticker = "is_sticker"
        case importDatetime = "import_datetime"
        case trendingDatetime = "trending_datetime"
        case images, user
        case imageOriginalURL = "image_original_url"
        case imageURL = "image_url"
        case imageMp4URL = "image_mp4_url"
        case imageFrames = "image_frames"
        case imageWidth = "image_width"
        case imageHeight = "image_height"
        case fixedHeightDownsampledURL = "fixed_height_downsampled_url"
        case fixedHeightDownsampledWidth = "fixed_height_downsampled_width"
        case fixedHeightDownsampledHeight = "fixed_height_downsampled_height"
        case fixedWidthDownsampledURL = "fixed_width_downsampled_url"
        case fixedWidthDownsampledWidth = "fixed_width_downsampled_width"
        case fixedWidthDownsampledHeight = "fixed_width_downsampled_height"
        case fixedHeightSmallURL = "fixed_height_small_url"
        case fixedHeightSmallStillURL = "fixed_height_small_still_url"
        case fixedHeightSmallWidth = "fixed_height_small_width"
        case fixedHeightSmallHeight = "fixed_height_small_height"
        case fixedWidthSmallURL = "fixed_width_small_url"
        case fixedWidthSmallStillURL = "fixed_width_small_still_url"
        case fixedWidthSmallWidth = "fixed_width_small_width"
        case fixedWidthSmallHeight = "fixed_width_small_height"
        case caption
    }
}

// MARK: - Images
struct Images: Codable {
    let downsizedLarge, fixedHeightSmallStill: The480_WStill
    let original, fixedHeightDownsampled: FixedHeight
    let downsizedStill, fixedHeightStill, downsizedMedium, downsized: The480_WStill
    let previewWebp: The480_WStill
    let originalMp4: DownsizedSmall
    let fixedHeightSmall, fixedHeight: FixedHeight
    let downsizedSmall, preview: DownsizedSmall
    let fixedWidthDownsampled: FixedHeight
    let fixedWidthSmallStill: The480_WStill
    let fixedWidthSmall: FixedHeight
    let originalStill, fixedWidthStill: The480_WStill
    let looping: Looping
    let fixedWidth: FixedHeight
    let previewGIF, the480WStill: The480_WStill

    enum CodingKeys: String, CodingKey {
        case downsizedLarge = "downsized_large"
        case fixedHeightSmallStill = "fixed_height_small_still"
        case original
        case fixedHeightDownsampled = "fixed_height_downsampled"
        case downsizedStill = "downsized_still"
        case fixedHeightStill = "fixed_height_still"
        case downsizedMedium = "downsized_medium"
        case downsized
        case previewWebp = "preview_webp"
        case originalMp4 = "original_mp4"
        case fixedHeightSmall = "fixed_height_small"
        case fixedHeight = "fixed_height"
        case downsizedSmall = "downsized_small"
        case preview
        case fixedWidthDownsampled = "fixed_width_downsampled"
        case fixedWidthSmallStill = "fixed_width_small_still"
        case fixedWidthSmall = "fixed_width_small"
        case originalStill = "original_still"
        case fixedWidthStill = "fixed_width_still"
        case looping
        case fixedWidth = "fixed_width"
        case previewGIF = "preview_gif"
        case the480WStill = "480w_still"
    }
}

// MARK: - The480_WStill
struct The480_WStill: Codable {
    let url: String
    let width, height: String
    let size: String?
}

// MARK: - DownsizedSmall
struct DownsizedSmall: Codable {
    let height: String
    let mp4: String
    let mp4Size, width: String

    enum CodingKeys: String, CodingKey {
        case height, mp4
        case mp4Size = "mp4_size"
        case width
    }
}

// MARK: - FixedHeight
struct FixedHeight: Codable {
    let height: String
    let mp4: String?
    let mp4Size: String?
    let size: String
    let url: String
    let webp: String
    let webpSize, width: String
    let frames, hash: String?

    enum CodingKeys: String, CodingKey {
        case height, mp4
        case mp4Size = "mp4_size"
        case size, url, webp
        case webpSize = "webp_size"
        case width, frames, hash
    }
}

// MARK: - Looping
struct Looping: Codable {
    let mp4: String
    let mp4Size: String

    enum CodingKeys: String, CodingKey {
        case mp4
        case mp4Size = "mp4_size"
    }
}

// MARK: - User
struct User: Codable {
    let avatarURL: String
    let bannerImage, bannerURL: String
    let profileURL: String
    let username, displayName, userDescription: String
    let isVerified: Bool
    let websiteURL: String
    let instagramURL: String

    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
        case bannerImage = "banner_image"
        case bannerURL = "banner_url"
        case profileURL = "profile_url"
        case username
        case displayName = "display_name"
        case userDescription = "description"
        case isVerified = "is_verified"
        case websiteURL = "website_url"
        case instagramURL = "instagram_url"
    }
}

// MARK: - Meta
struct Meta: Codable {
    let status: Int
    let msg, responseID: String

    enum CodingKeys: String, CodingKey {
        case status, msg
        case responseID = "response_id"
    }
}
