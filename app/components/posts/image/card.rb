module Components
  module Posts
    class Image::Card < Components::Base
      include Phlex::Rails::Helpers::DOMID

      def initialize(post:)
        @post = post
      end

      def view_template(&)
        Components::Posts::Card() do
          Components::Posts::CardThumb() { image }
          Components::Posts::CardPrimaryActions() do |pa|
            pa.with_primary { Components::Posts::SaveBtn(post: @post) } if authenticated?
          end
          Components::Posts::CardMeta(
            title: @post.title,
            datetime: @post.created_at,
            author: @post.user
          )
        end
      end

      private

      def image
        img(src: rails_blob_path(@post.files.first.variant(:square_350)), width: 350, loading: :lazy, class: "w-full h-full object-contain")
      end
    end
  end
end
