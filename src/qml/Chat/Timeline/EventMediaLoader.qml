import QtQuick 2.12
import "../../Base"
import "../../utils.js" as Utils

HLoader {
    id: loader
    x: eventContent.spacing


    property QtObject singleMediaInfo
    property url mediaUrl

    readonly property var imageExtensions: [
		"bmp", "gif", "jpg", "jpeg", "png", "pbm", "pgm", "ppm", "xbm", "xpm",
		"tiff", "webp", "svg",
    ]

    readonly property var videoExtensions: [
        "3gp", "avi", "flv", "m4p", "m4v", "mkv", "mov", "mp4",
		"mpeg", "mpg", "ogv", "qt", "vob", "webm", "wmv", "yuv",
    ]

    readonly property var audioExtensions: [
        "pcm", "wav", "raw", "aiff", "flac", "m4a", "tta", "aac", "mp3",
        "ogg", "oga", "opus",
    ]

    readonly property int type: {
        let main_type = singleMediaInfo.media_mime.split("/")[0].toLowerCase()

        if (main_type === "image") return EventDelegate.Media.Image
        if (main_type === "video") return EventDelegate.Media.Video
        if (main_type === "audio") return EventDelegate.Media.Audio

        if (singleMediaInfo.event_type === "RoomMessageFile")
            return EventDelegate.Media.File

        // If this is a preview for a link in a normal message
        let ext = Utils.urlExtension(mediaUrl)

        if (imageExtensions.includes(ext)) return EventDelegate.Media.Image
        if (videoExtensions.includes(ext)) return EventDelegate.Media.Video
        if (audioExtensions.includes(ext)) return EventDelegate.Media.Audio

        return EventDelegate.Media.Page
    }

    readonly property url previewUrl: (
        type === EventDelegate.Media.File ||
        type === EventDelegate.Media.Image ?
        singleMediaInfo.thumbnail_url : ""
    ) || mediaUrl


    onPreviewUrlChanged: {
        if (type === EventDelegate.Media.Image) {
            var file  = "EventImage.qml"
            var props = {
                thumbnailUrl: previewUrl,
                fullImageUrl: mediaUrl,
                animated:     singleMediaInfo.media_mime === "image/gif" ||
                              Utils.urlExtension(mediaUrl) === "gif",
            }

        // } else if (type === EventDelegate.Media.File) {
        //     var file  = "EventFile.qml"
        //     var props = {
        //         thumbnailUrl: previewUrl,
        //         fileUrl:      mediaUrl,
        //         fileTitle:    info.media_title,
        //         fileSize:     info.media_size,
        //     }

        // } else if (type === EventDelegate.Media.Video) {
        //     var file  = "EventVideo.qml"
        //     var props = { source: mediaUrl }

        // } else if (type === EventDelegate.Media.Audio) {
        //     var file  = "EventAudio.qml"
        //     var props = { source: mediaUrl }

        } else { return }

        loader.setSource(file, props)
    }
}
