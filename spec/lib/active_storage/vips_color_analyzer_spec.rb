# frozen_string_literal: true

require "rails_helper"

describe ActiveStorage::VipsColorAnalyzer do
  def create_blob(path, content_type)
    ActiveStorage::Blob.create_and_upload!(
      io: File.open(path),
      filename: File.basename(path),
      content_type: content_type
    )
  end

  describe ".accept?" do
    it "accepts image blobs" do
      blob = create_blob("spec/fixtures/files/1x1.jpg", "image/jpeg")
      expect(described_class.accept?(blob)).to be true
    end

    it "rejects non-image blobs" do
      blob = ActiveStorage::Blob.create_and_upload!(
        io: StringIO.new("hello"),
        filename: "hello.txt",
        content_type: "text/plain"
      )
      expect(described_class.accept?(blob)).to be false
    end
  end

  describe "#metadata" do
    it "returns width, height, blurhash and the dominant color for a solid-color image" do
      blob = create_blob("spec/fixtures/files/1x1.jpg", "image/jpeg")

      expect(described_class.new(blob).metadata).to eq(
        width: 1,
        height: 1,
        blurhash: "L~TSUA~q~q~q~q~q~q~q~q~q~q~q",
        dominant_colors: [ { color: "#ffffff", percentage: 100.0 } ]
      )
    end

    it "returns width, height, blurhash and the exact dominant palette for a multi-color image" do
      blob = create_blob("spec/fixtures/files/screenshot.png", "image/png")

      expect(described_class.new(blob).metadata).to eq(
        width: 351,
        height: 16,
        blurhash: "L_NyK|FA|V]3$AWmsSsSfQfQfQfQ",
        dominant_colors: [
          { color: "#ff00ff", percentage: 41.0 },
          { color: "#0000ff", percentage: 36.5 },
          { color: "#ff0000", percentage: 20.5 },
          { color: "#fb0004", percentage: 0.5 },
          { color: "#cb0034", percentage: 0.5 },
          { color: "#0500fa", percentage: 0.5 },
          { color: "#0100ff", percentage: 0.5 }
        ]
      )
    end
  end
end
