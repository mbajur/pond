class ActiveStorage::ImageMagickColorAnalyzer < ActiveStorage::Blurhash::Analyzer::ImageMagick
  COLOR_COUNT = 5

  def self.accept?(blob)
    blob.image? && ActiveStorage::MINIMAGICK_AVAILABLE
  end

  def metadata
    super.merge(dominant_colors: extract_colors_from_thumbnail)
  end

  private

  def extract_colors_from_thumbnail
    read_image do |image|
      build_thumbnail(image)
      extract_colors(thumbnail)
    end
  end

  def extract_colors(image)
    histogram = Colorscore::Histogram.new(image.path)

    histogram.scores.first(6).map do |score, color|
      { color: color.html.upcase, percentage: (score * 100).round(2) }
    end
  end
end
