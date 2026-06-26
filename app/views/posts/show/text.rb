module Views
  module Posts
    class Show::Text < Views::Base
      def initialize(post:, pins:)
        @post = post
        @pins = pins
      end

      def view_template(&)
        Components::Posts::ShowContent() do |sc|
          sc.with_preview do
            div(class: "border-r p-6 h-full w-full flex items-center justify-center") do
              div(class: "bg-muted prose prose-h1:font-bold prose-h2:font-bold p-12") do
                raw marksmithed(@post.content).html_safe
              end
            end
          end

          sc.with_sidebar do
            render Views::Posts::Show::Sidebar.new(post: @post, pins: @pins)
          end
        end
      end

      private

      def image
        if @post.screenshot.attached?
          image_tag(@post.screenshot, class: "object-fit")
        elsif @post.url_cache&.thumb.attached?
          image_tag(@post.url_cache.thumb, class: "object-fit")
        end
      end
    end
  end
end
