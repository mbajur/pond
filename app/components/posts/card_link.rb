module Components
  module Posts
    class CardLink < Components::Base
      def initialize(href:)
        @href = href
      end

      def view_template(&)
        a(href: @href, class: "absolute inset-0 z-8 pin-link")
      end
    end
  end
end
