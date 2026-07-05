require "vips"
require "kmeans-clusterer"
require "color"

# Extract dominant colors and their percentages from an image using vips and
# KMeans clustering.
class ImageColorPaletteExtractor
  CLUSTER_COUNT = 8
  KMEANS_RUNS = 5
  MAX_DIMENSION = 200.0

  def initialize(image, reject_background: false)
    @image = image
    @reject_background = reject_background
  end

  def call
    image = load_image
    vectors = extract_pixel_vectors(image)
    clusters = cluster_pixels(vectors)

    build_palette(vectors, clusters)
  end

  private

  def load_image
    img = @image.respond_to?(:write_to_memory) ? @image : Vips::Image.new_from_file(@image)
    img = img.flatten if img.has_alpha?
    scale = [ MAX_DIMENSION / img.width, MAX_DIMENSION / img.height ].min
    img.resize(scale)
  end

  def extract_pixel_vectors(image)
    pixels = image.write_to_memory.unpack("C*")
    pixels.each_slice(image.bands).map { |p| [ p[0].to_f, p[1].to_f, p[2].to_f ] }
  end

  def cluster_pixels(vectors)
    KMeansClusterer.run(CLUSTER_COUNT, vectors, runs: KMEANS_RUNS)
  end

  def build_palette(vectors, result)
    counts = count_pixels_per_cluster(vectors, result.clusters)

    entries = counts.filter_map do |cluster, count|
      rgb = cluster.centroid.instance_variable_get(:@data).map(&:round)
      next if @reject_background && background?(rgb)

      { rgb: rgb, count: count }
    end

    total = entries.sum { |e| e[:count] }
    return [] if total.zero?

    entries.sort_by { |e| -e[:count] }.map do |entry|
      { color: Color::RGB.from_values(*entry[:rgb]).html,
        percentage: (entry[:count] * 100.0 / total).round(2) }
    end
  end

  def count_pixels_per_cluster(vectors, clusters)
    counts = Hash.new(0)
    vectors.each do |pixel|
      nearest = clusters.min_by do |cluster|
        c = cluster.centroid
        (pixel[0] - c[0])**2 + (pixel[1] - c[1])**2 + (pixel[2] - c[2])**2
      end
      counts[nearest] += 1
    end
    counts
  end

  def background?(rgb)
    rgb.max > 245 && rgb.min > 245
  end
end
