module Views
  module Posts
    class Show::Image < Views::Base
      include Phlex::Rails::Helpers::LinkTo
      include Phlex::Rails::Helpers::ImageTag

      def initialize(post:, pins:)
        @post = post
        @pins = pins
      end

      def view_template(&)
        Components::Posts::ShowContent() do |sc|
          sc.with_preview do
            div(class: "border-r p-6 h-full w-full flex items-center justify-center") do
              source_link_wrap do
                image
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
        image_tag(rails_blob_path(@post.files.first), class: "object-contain")
      end

      def source_link_wrap(&block)
        if @post.url.present?
          link_to @post.url, rel: :nofollow, class: "max-w-full max-h-full" do
            yield
          end
        else
          div(class: "max-w-full max-h-full") do
            yield
          end
        end
      end
    end
  end
end
