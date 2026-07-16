# frozen_string_literal: true

class Views::Posts::Edit < Views::Base
  include Phlex::Rails::Helpers::TurboFrameTag
  include Phlex::Rails::Helpers::FormWith

  def initialize(opts = {})
    @opts = opts
    @post = opts[:post]
  end

  def view_template
    Components::PageWrapFitScreen() do
      if @post.is_a?(Post::Url)
        render Views::Posts::Edit::Url.new(**@opts)
      elsif @post.is_a?(Post::Text)
        render Views::Posts::Edit::Text.new(**@opts)
      elsif @post.is_a?(Post::Image)
        render Views::Posts::Edit::Image.new(**@opts)
      else
        raise "Unknown post type: #{@post.class.name}"
      end
    end
  end
end
