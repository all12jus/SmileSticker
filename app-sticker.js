// This script creates app icons for Apple apps, from an svg file.

var fs = require("fs");
var sharp = require("sharp");
var async = require("async");
// This doesn't work because some duplicate sizes are required.
// stickersiconset
var sizeObjects = [
    // iphone
    // { size: { x: 29, y: 29 }, multiplier: 2, idiom: "iphone" },
    // { size: { x: 29, y: 29 }, multiplier: 3, idiom: "iphone" },
    { size: { x: 60, y: 45 }, multiplier: 2, idiom: "iphone" },
    { size: { x: 60, y: 45 }, multiplier: 3, idiom: "iphone" },

    // { size: { x: 29, y: 29 }, multiplier: 2, idiom: "ipad" },
    { size: { x: 67, y: 50 }, multiplier: 2, idiom: "ipad" },
    { size: { x: 74, y: 55 }, multiplier: 2, idiom: "ipad" },

    // Appstore
    // { size: { x: 1024, y: 1024 }, multiplier: 1, idiom: "ios-marketing" },
    { size: { x: 1024, y: 768 }, multiplier: 1, idiom: "ios-marketing" },

    {
        size: { x: 27, y: 20 },
        multiplier: 2,
        idiom: "universal",
        platform: "ios"
    },
    {
        size: { x: 27, y: 20 },
        multiplier: 3,
        idiom: "universal",
        platform: "ios"
    },
    {
        size: { x: 32, y: 24 },
        multiplier: 2,
        idiom: "universal",
        platform: "ios"
    },
    {
        size: { x: 32, y: 24 },
        multiplier: 3,
        idiom: "universal",
        platform: "ios"
    }
];
var directory =
    process.cwd() +
    "/SmileSticker MessagesExtension/Assets.xcassets/iMessage App Icon.stickersiconset";
var inputFile = "appicon-wide.svg";

// fs.mkdirSync(directory);

var iconContents = {
    images: [],
    info: {
        version: 1,
        author: "xcode"
    }
};
async.eachSeries(
    sizeObjects,
    function function_name(icon, callback) {
        console.log(icon);
        var output =
            icon.idiom +
            "-" +
            icon.size.x +
            "x" +
            icon.size.y +
            // "x" +
            // icon.size +
            (icon.multiplier > 1 ? "@" + icon.multiplier + "x" : "") +
            ".png";
        var content = fs.readFileSync(inputFile, "utf8");
        var buffer = Buffer.from(content, "utf8");
        sharp(buffer)
            .resize(
                icon.size.x * icon.multiplier,
                icon.size.y * icon.multiplier
            )
            .png()
            .flatten()
            .toFile(directory + "/" + output, function(err) {
                console.log("finished one?");
                if (err) {
                    console.log(err);
                    process.exit(-1);
                }
                callback(err);
            });
        var imgObject = {
            size: icon.size.x + "x" + icon.size.y,
            idiom: icon.idiom,
            // can add in the stuff to handle light and dark mode
            filename: output,
            platform: icon.platform || undefined,
            scale: icon.multiplier + "x"
        };
        console.log(imgObject);
        iconContents.images.push(imgObject);
        // if (true) callback();
    },
    function completed(err) {
        if (err) {
            console.log(err);
        } else {
            console.log("done?");
            fs.writeFileSync(
                directory + "/Contents.json",
                JSON.stringify(iconContents, null, 4)
            );
        }
    }
);
