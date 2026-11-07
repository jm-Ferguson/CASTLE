#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonParseError>
#include <QDebug>
#include <QString>

#include <cmath>
#include <cstddef>
#include <cstdint>
#include <optional>
#include <vector>

// One depth image: dimensions plus millimeter measurements.
struct DepthFrame {
    int width = 0;
    int height = 0;

    // Stored row by row. Zero means no measurement.
    // Pixel index = row * width + column.
    std::vector<std::uint16_t> depthMm;
};


// Checks the JSON before we convert it into a DepthFrame.
bool validateDepthJson(const QJsonObject& json)
{
    // Check how the file says its measurements should be interpreted.
    if (json["schema"].toString() != "castle.depth.v1" ||
        json["order"].toString() != "row-major" ||
        json["depthUnits"].toString() != "millimeters" ||
        json["depthMeaning"].toString() != "camera-z" ||
        !json["invalidDepth"].isDouble() ||
        json["invalidDepth"].toDouble() != 0) {
        qWarning() << "Unsupported depth-file format.";
        return false;
    }

    // Require whole-number dimensions within the HTML editor's limits.
    double width = json["width"].toDouble(-1);
    double height = json["height"].toDouble(-1);

    if (!std::isfinite(width) ||
        !std::isfinite(height) ||
        width < 2 || width > 1920 ||
        height < 2 || height > 1080 ||
        std::floor(width) != width ||
        std::floor(height) != height) {
        qWarning() << "Invalid frame dimensions.";
        return false;
    }

    if (!json["depthMm"].isArray()) {
        qWarning() << "Missing depth array.";
        return false;
    }

    QJsonArray depths = json["depthMm"].toArray();

    // There must be one measurement for every pixel.
    std::size_t expectedSamples =
        static_cast<std::size_t>(width) *
        static_cast<std::size_t>(height);

    if (static_cast<std::size_t>(depths.size()) != expectedSamples) {
        qWarning() << "Depth sample count doesn't match the dimensions.";
        return false;
    }

    // Every measurement must fit in an unsigned 16-bit integer.
    for (const QJsonValue& sample : depths) {
        double value = sample.toDouble(-1);

        if (!sample.isDouble() ||
            !std::isfinite(value) ||
            value < 0 || value > 65535 ||
            std::floor(value) != value) {
            qWarning() << "Invalid depth measurement.";
            return false;
        }
    }

    return true;
}


// Reads a saved depth image.
// Returns a frame on success, or std::nullopt on failure.
std::optional<DepthFrame> loadDepthFile()
{
    QFile file("castle-depth.json");
    
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Could not open file:" << file.errorString();
        return std::nullopt;
    }

    // 2. Parse the file's text as JSON.
    QJsonParseError error;
    QJsonDocument document =
        QJsonDocument::fromJson(file.readAll(), &error);

    if (error.error != QJsonParseError::NoError) {
        qWarning() << "Invalid JSON:" << error.errorString();
        return std::nullopt;
    }

    if (!document.isObject()) {
        qWarning() << "Expected a JSON object.";
        return std::nullopt;
    }

    QJsonObject json = document.object();

    // 3. Check the format and measurements.
    if (!validateDepthJson(json)) {
        return std::nullopt;
    }

    // 4. Copy the validated data into a C++ frame.
    DepthFrame frame;
    frame.width = json["width"].toInt();
    frame.height = json["height"].toInt();

    QJsonArray depths = json["depthMm"].toArray();
    frame.depthMm.reserve(depths.size());

    for (const QJsonValue& sample : depths) {
        frame.depthMm.push_back(
            static_cast<std::uint16_t>(sample.toInt())
        );
    }

    // 5. Return the completed frame.
    return frame;
}