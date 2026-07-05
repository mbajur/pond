module Components
  module Posts
    class CardSourceLink < Components::Base
      def initialize(url:)
        @url = url
      end

      def view_template(&)
        Link(href: @url, variant: :primary, rel: :nofollow) { "Source ↗" }
      end
    end
  end
end
