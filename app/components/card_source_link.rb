module Components
  class CardSourceLink < Components::Base
    def initialize(url:)
      @url = url
    end

    def view_template(&)
      Link(href: @url, size: :sm, variant: :primary, rel: :nofollow) { "Source ↗" }
    end
  end
end
