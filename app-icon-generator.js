// This script creates app icons for Apple apps, from an svg file.

var fs = require("fs");
var sharp = require("sharp");
var async = require("async");
// This doesn't work because some duplicate sizes are required.
// stickersiconset
var sizeObjects = [
    // iphone
    { size: 20, multiplier: 2, idiom: "iphone" },
    { size: 20, multiplier: 3, idiom: "iphone" },
    { size: 29, multiplier: 2, idiom: "iphone" },
    { size: 29, multiplier: 3, idiom: "iphone" },
    { size: 40, multiplier: 2, idiom: "iphone" },
    { size: 40, multiplier: 3, idiom: "iphone" },
    { size: 60, multiplier: 2, idiom: "iphone" },
    { size: 60, multiplier: 3, idiom: "iphone" },

    // ipad
    { size: 20, multiplier: 1, idiom: "ipad" },
    { size: 20, multiplier: 2, idiom: "ipad" },
    { size: 29, multiplier: 1, idiom: "ipad" },
    { size: 29, multiplier: 2, idiom: "ipad" },
    { size: 40, multiplier: 1, idiom: "ipad" },
    { size: 40, multiplier: 2, idiom: "ipad" },
    { size: 76, multiplier: 1, idiom: "ipad" },
    { size: 76, multiplier: 2, idiom: "ipad" },
    { size: 83.5, multiplier: 2, idiom: "ipad" },

    // Apple watch
    // { size: 20,   multiplier: 1, idiom: 'ipad'},

    /*
{
      "size" : "24x24",
      "idiom" : "watch",
      "scale" : "2x",
      "role" : "notificationCenter",
      "subtype" : "38mm"
    },

*/

    // Appstore
    { size: 1024, multiplier: 1, idiom: "ios-marketing" }
];
var directory =
    process.cwd() + "/SmileSticker/Assets.xcassets/AppIcon.appiconset";
var inputFile = "appicon.svg";
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
            icon.size +
            "x" +
            icon.size +
            (icon.multiplier > 1 ? "@" + icon.multiplier + "x" : "") +
            ".png";
        var content = fs.readFileSync(inputFile, "utf8");
        var buffer = Buffer.from(content, "utf8");
        sharp(buffer)
            .resize(icon.size * icon.multiplier, icon.size * icon.multiplier)
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
            size: icon.size + "x" + icon.size,
            idiom: icon.idiom,
            // can add in the stuff to handle light and dark mode
            filename: output,
            scale: icon.multiplier + "x"
        };
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
