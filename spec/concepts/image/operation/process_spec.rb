# frozen_string_literal: true

require "rails_helper"

describe Image::Operation::Process do
  def tempfile_for(path, ext)
    Tempfile.new([ "fixture", ext ]).tap do |f|
      f.binmode
      f.write(File.binread(path))
      f.flush
      f.rewind
    end
  end

  describe ".call" do
    context "when no image is given" do
      it "fails without producing an output" do
        result = described_class.call(params: { image: nil })

        expect(result).not_to be_success
        expect(result[:output]).to be_nil
      end
    end

    context "when the re-encoded webp is smaller than the original" do
      let(:file) { tempfile_for("spec/fixtures/files/1x1.jpg", ".jpg") }

      it "outputs the webp version" do
        output = described_class.call(params: { image: file })[:output]

        expect(output[:content_type]).to eq("image/webp")
        expect(output[:filename]).to end_with(".webp")
        expect(output[:io].size).to be < File.size(file.path)
      end
    end

    context "when the original is smaller than the re-encoded webp" do
      let(:file) { tempfile_for("spec/fixtures/files/1x1.gif", ".gif") }

      it "outputs the untouched original" do
        output = described_class.call(params: { image: file })[:output]

        expect(output[:content_type]).to eq("image/gif")
        expect(output[:filename]).to end_with(".gif")
        expect(output[:io].read).to eq(File.binread(file.path))
      end
    end

    context "when the image exceeds MAX_SIDE" do
      let(:file) do
        image = Vips::Image.black(2000, 100) + [ 255, 0, 0 ]
        Tempfile.new([ "big", ".png" ]).tap { |f| image.write_to_file(f.path) }
      end

      it "downscales the longest side to MAX_SIDE, keeping the aspect ratio" do
        output = described_class.call(params: { image: file })[:output]
        resized = Vips::Image.new_from_buffer(output[:io].read, "")

        expect(resized.width).to eq(described_class::MAX_SIDE)
        expect(resized.height).to eq(100 * described_class::MAX_SIDE / 2000)
      end
    end
  end
end
