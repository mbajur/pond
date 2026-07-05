module Components
  module Posts
    class PostCard::ThumbBase < Components::Base
      include Phlex::Rails::Helpers::DOMID

      def initialize(post:)
        @post = post
      end

      private

      def container(&)
        div(class: container_classes, &)
      end

      def core_container_classes
        "w-full aspect-square bg-muted flex items-center overflow-hidden"
      end

      def container_classes
        core_container_classes + " #{dom_id(@post, :thumb)}"
      end
    end
  end
end
