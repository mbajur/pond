module Components
  module Posts
    class Url::PrimaryActions < PostCard::PrimaryActionsBase
      private

      def source_url
        @post.url
      end
    end
  end
end
