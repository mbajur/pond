class ActiveStorage::VipsColorAnalyzer < ActiveStorage::Blurhash::Analyzer::Vips
  def self.accept?(blob)
    blob.image? && ActiveStorage::VIPS_AVAILABLE
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
    ImageColorPaletteExtractor.new(image).call
  end
end
