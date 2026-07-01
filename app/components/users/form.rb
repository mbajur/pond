module Components
  module Users
    class Form < Components::Base
      include Phlex::Rails::Helpers::FormWith

      def initialize(user:)
        @user = user
      end

      def view_template(&)
        form_with(model: @user, id: :user_form) do |f|
          div(class: "mb-6") do
            f.label(:name, "Display name", class: "font-semibold mb-1 block")
            f.text_field(:name, required: true, class: "flex h-9 w-full rounded-md border bg-background px-3 py-1 text-sm shadow-xs transition-[color,box-shadow] border-border ring-0 ring-ring/0 placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50 file:border-0 file:bg-transparent file:text-sm file:font-medium aria-disabled:cursor-not-allowed aria-disabled:opacity-50 aria-disabled:pointer-events-none focus-visible:outline-none focus-visible:ring-ring/50 focus-visible:ring-2 focus-visible:border-ring focus-visible:shadow-sm", autocomplete: "off")
          end

          div(class: "mb-6") do
            f.label(:description, class: "font-semibold mb-1 block")
            f.text_area(:description, placeholder: "Add an optional description to your profile...", rows: 3, class: "flex w-full rounded-md border bg-background px-3 py-2 text-sm shadow-sm transition-colors border-border placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50 file:border-0 file:bg-transparent file:text-sm file:font-medium focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring aria-disabled:cursor-not-allowed aria-disabled:opacity-50 aria-disabled:pointer-events-none")
          end

          render Components::Ui::Flex do
            div(class: "flex-1") do
              p(class: "font-semibold") { "Make it private" }
              Text(size: "2", class: "text-muted-foreground") { "Will only be visible to you" }
            end

            div(class: "") do
              label(role: "switch", class: "peer inline-flex h-6 w-11 shrink-0 cursor-pointer items-center rounded-full border-2 border-transparent transition-colors bg-input has-checked:bg-primary has-disabled:cursor-not-allowed has-disabled:opacity-50 has-aria-disabled:cursor-not-allowed has-aria-disabled:opacity-50 has-aria-disabled:pointer-events-none focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background") do
                f.check_box(:private, class: "hidden peer")
                span(class: "pointer-events-none block h-5 w-5 rounded-full bg-background shadow-lg ring-0 transition-transform translate-x-0 peer-checked:translate-x-5")
              end
            end
          end
        end
      end
    end
  end
end
