module Views
  module Posts
    class Show < Views::Base
      def initialize(opts = {})
        @opts = opts
        @post = opts[:post]
      end

      def view_template(&)
        Components::PageWrapFitScreen() do
          if @post.is_a?(Post::Url)
            render Views::Posts::Show::Url.new(**@opts)
          elsif @post.is_a?(Post::Text)
            render Views::Posts::Show::Text.new(**@opts)
          elsif @post.is_a?(Post::Image)
            render Views::Posts::Show::Image.new(**@opts)
          else
            raise "Unknown post type: #{@post.class.name}"
          end
        end
      end
    end
  end
end
