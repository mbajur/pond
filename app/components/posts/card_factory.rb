module Components
  module Posts
    class CardFactory
      def self.new(post, **opts)
        case post.class.name
        when "Post::Text"
          Text::Card.new(post: post, **opts)
        when "Post::Image"
          Image::Card.new(post: post, **opts)
        when "Post::Url"
          Url::Card.new(post: post, **opts)
        else
          raise "Unknown post type: #{post.class.name}"
        end
      end
    end
  end
end
