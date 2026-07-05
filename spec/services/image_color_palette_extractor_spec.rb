# frozen_string_literal: true

require "rails_helper"

describe ImageColorPaletteExtractor do
  let(:screenshot_path) { Rails.root.join("spec/fixtures/files/screenshot.png").to_s }
  let(:solid_white_path) { Rails.root.join("spec/fixtures/files/1x1.jpg").to_s }

  # screenshot.png is a flat-color mock made of magenta/blue/red blocks, so the
  # palette (and the tiny resize-antialiasing slivers along the block edges) is
  # exactly reproducible run to run.
  let(:expected_palette) do
    [
      { color: "#ff00ff", percentage: 40.5 },
      { color: "#0000ff", percentage: 36.5 },
      { color: "#ff0000", percentage: 20.5 },
      { color: "#fc0003", percentage: 0.5 },
      { color: "#bc0043", percentage: 0.5 },
      { color: "#0400fb", percentage: 0.5 },
      { color: "#1600ff", percentage: 0.5 },
      { color: "#fa00ff", percentage: 0.5 }
    ]
  end

  describe "#call" do
    subject(:palette) { described_class.new(screenshot_path).call }

    it "returns the exact dominant colors and percentages" do
      expect(palette).to eq(expected_palette)
    end

    it "orders entries from most to least dominant" do
      percentages = palette.map { |entry| entry[:percentage] }
      expect(percentages).to eq(percentages.sort.reverse)
    end

    it "accepts an already-loaded Vips::Image instead of a path" do
      image = Vips::Image.new_from_file(screenshot_path)
      result = described_class.new(image).call

      expect(result).to eq(expected_palette)
    end

    context "with a single-color image" do
      subject(:palette) { described_class.new(solid_white_path).call }

      it "returns a single entry at 100%" do
        expect(palette).to eq([ { color: "#ffffff", percentage: 100.0 } ])
      end
    end
  end

  describe "reject_background option" do
    it "leaves the palette untouched when there is no near-white cluster" do
      palette = described_class.new(screenshot_path, reject_background: true).call

      expect(palette).to eq(expected_palette)
    end

    it "returns an empty array when the whole image is background" do
      palette = described_class.new(solid_white_path, reject_background: true).call

      expect(palette).to eq([])
    end
  end
end
