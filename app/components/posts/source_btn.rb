module Components
  module Posts
    class SourceBtn < Components::Base
      include Phlex::Rails::Helpers::LinkTo

      def initialize(href:, classes: "")
        @href = href
        @classes = classes
      end

      def view_template(&)
        Link(href: @href, variant: :secondary, size: :sm, rel: :nofollow, class: @classes) { "Source ↗" }
      end
    end
  end
end
