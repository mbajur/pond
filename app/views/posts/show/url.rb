module Views
  module Posts
    class Show::Url < Views::Base
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
              link_to @post.url, class: "max-w-full max-h-full" do
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
        if @post.screenshot.attached?
          image_tag(rails_blob_path(@post.screenshot), class: "object-contain")
        elsif @post.thumb.attached?
          image_tag(rails_blob_path(@post.thumb), class: "object-contain")
        end
      end
    end
  end
end
