# frozen_string_literal: true

module RubyUI
  class SidebarTrigger < Base
    def view_template(&)
      Button(variant: :ghost, size: :icon, **attrs) do
        Components::Icons::Menu()
        span(class: "sr-only") { "Toggle Sidebar" }
      end
    end

    private

    def default_attrs
      {
        class: "h-7 w-7 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0",
        data: {
          sidebar: "trigger",
          action: "click->ruby-ui--sidebar#toggle"
        }
      }
    end
  end
end
