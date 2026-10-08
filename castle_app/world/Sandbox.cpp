#include <cstddef>
#include <cstdint>
#include <optional>
#include <stdexcept>
#include <vector>

struct Position {
    float x;
    float y;
    float z;
};

struct Hand {
    std::uint64_t id;
    Position position;
};

struct Object {
    std::uint64_t id;
    Position position;
};

enum class Visibility {
    Unknown,
    Visible,
    Obstructed
};

struct TerrainCell {
    // No value means this location has never been measured.
    std::optional<float> height;
    Visibility visibility = Visibility::Unknown;
};

class Sandbox {
public:
    // All dimensions and positions are in meters.
    // X = width, Y = height, Z = depth.
    Sandbox(float width, float depth, std::size_t columns, std::size_t rows)
        : width_(width),
          depth_(depth),
          columns_(columns),
          rows_(rows){
        if (width <= 0 || depth <= 0 || columns < 2 || rows < 2) {
            throw std::invalid_argument("Invalid sandbox dimensions");
        }

        // Every cell starts unknown, with no measured height.
        terrain_.resize(columns * rows);
    }

    float width() const { return width_; }
    float depth() const { return depth_; }

    std::size_t columns() const { return columns_; }
    std::size_t rows() const { return rows_; }

    const TerrainCell& terrainAt(std::size_t x, std::size_t z) const {
        return terrain_.at(indexOf(x, z));
    }

    void updateHeight(std::size_t x, std::size_t z, float height) {
        auto& cell = terrain_.at(indexOf(x, z));

        cell.height = height;
        cell.visibility = Visibility::Visible;
    }

    void markObstructed(std::size_t x, std::size_t z) {
        // Preserve the previous height, if one exists.
        terrain_.at(indexOf(x, z)).visibility = Visibility::Obstructed;
    }

    void markUnknown(std::size_t x, std::size_t z) {
        // No reliable current observation; preserve any previous height.
        terrain_.at(indexOf(x, z)).visibility = Visibility::Unknown;
    }

    const std::vector<Hand>& hands() const {
        return hands_;
    }

    const std::vector<Object>& objects() const {
        return objects_;
    }

    // Replace the current detections. An empty vector clears them.
    void setHands(const std::vector<Hand>& hands) {
        hands_ = hands;
    }

    void setObjects(const std::vector<Object>& objects) {
        objects_ = objects;
    }

private:
    float width_;
    float depth_;

    std::size_t columns_;
    std::size_t rows_;

    std::vector<TerrainCell> terrain_;
    std::vector<Hand> hands_;
    std::vector<Object> objects_;

    std::size_t indexOf(std::size_t x, std::size_t z) const {
        if (x >= columns_ || z >= rows_) {
            throw std::out_of_range("Terrain coordinates outside sandbox");
        }

        return z * columns_ + x;
    }
};