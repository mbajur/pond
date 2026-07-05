# typed: false
# frozen_string_literal: true

module Image::Operation
  class Process < Trailblazer::Operation
    MAX_SIDE = 1440

    step :load
    step :resize
    step :generate_webp
    step :select_smaller

    private

    def load(ctx, params:, **)
      file = params[:image]
      return false unless file

      ctx[:original_path] = file.path
      ctx[:vips_image]    = Vips::Image.new_from_file(file.path)
    end

    def resize(ctx, vips_image:, **)
      max = [ vips_image.width, vips_image.height ].max
      return true if max <= MAX_SIDE

      ctx[:vips_image] = vips_image.resize(MAX_SIDE.to_f / max)
      ctx[:resized]    = true
    end

    def generate_webp(ctx, vips_image:, **)
      buffer = vips_image.write_to_buffer(".webp[Q=80]")
      ctx[:webp_buffer] = buffer
      ctx[:webp_size]   = buffer.bytesize
    end

    def select_smaller(ctx, original_path:, vips_image:, webp_buffer:, webp_size:, resized: false, **)
      if resized
        buf = encode_original(vips_image, original_path)
        original_io   = StringIO.new(buf).tap(&:rewind)
        original_size = buf.bytesize
      else
        original_io   = File.open(original_path, "rb")
        original_size = File.size(original_path)
      end

      if webp_size < original_size
        ctx[:output] = {
          io: StringIO.new(webp_buffer).tap(&:rewind),
          content_type: "image/webp",
          filename: "#{File.basename(original_path, ".*")}.webp"
        }
      else
        ctx[:output] = {
          io: original_io,
          content_type: Marcel::MimeType.for(Pathname.new(original_path)),
          filename: File.basename(original_path)
        }
      end
    end

    def encode_original(image, original_path)
      case File.extname(original_path).downcase
      when ".png"  then image.write_to_buffer(".png")
      when ".gif"  then image.write_to_buffer(".gif")
      when ".webp" then image.write_to_buffer(".webp[Q=85]")
      else              image.write_to_buffer(".jpg[Q=85]")
      end
    end
  end
end
