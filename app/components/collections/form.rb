module Components
  module Collections
    class Form < Components::Base
      include Phlex::Rails::Helpers::FormWith
      include Phlex::Rails::Helpers::ButtonTo

      def initialize(collection:)
        @collection = collection
      end

      def view_template(&)
        form_with(model: @collection, id: :collection_form) do |f|
          f.text_field(:name, placeholder: "Collection name...", required: true, class: "w-full mb-4 text-2xl text-center py-10", autocomplete: "off", autofocus: true)

          if @collection.persisted?
            div(class: "mb-6") do
              f.label(:description, class: "font-semibold mb-1 block")
              f.text_area(:description, placeholder: "Add an optional description to your collection...", rows: 3, class: "flex w-full rounded-md border bg-background px-3 py-2 text-sm shadow-sm transition-colors border-border placeholder:text-muted-foreground disabled:cursor-not-allowed disabled:opacity-50 file:border-0 file:bg-transparent file:text-sm file:font-medium focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring aria-disabled:cursor-not-allowed aria-disabled:opacity-50 aria-disabled:pointer-events-none")
            end
          end

          # render Components::Ui::Flex do
          #   div(class: "flex-1") do
          #     p(class: "font-semibold") { "Make it private" }
          #     Text(size: "2", class: "text-muted-foreground") { "Will only be visible to you" }
          #   end

          #   div(class: "") do
          #     label(role: "switch", class: "peer inline-flex h-6 w-11 shrink-0 cursor-pointer items-center rounded-full border-2 border-transparent transition-colors bg-input has-checked:bg-primary has-disabled:cursor-not-allowed has-disabled:opacity-50 has-aria-disabled:cursor-not-allowed has-aria-disabled:opacity-50 has-aria-disabled:pointer-events-none focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background") do
          #       f.check_box(:private, class: "hidden peer")
          #       span(class: "pointer-events-none block h-5 w-5 rounded-full bg-background shadow-lg ring-0 transition-transform translate-x-0 peer-checked:translate-x-5")
          #     end
          #   end
          # end
        end

        if @collection.persisted?
          div(class: "mt-6 mb-3") do
            Heading(level: 4) { "Danger zone" }
          end

          div(class: "grid grid-cols-12") do
            div(class: "col-span-6") do
              p(class: "font-semibold") { "Remove collection" }
              Text(size: "2", class: "text-muted-foreground") { "Removes the collection and all its pins. This cannnot be undone." }
            end

            div(class: "col-span-6 text-right") do
              button_to("Remove", collection_path(@collection), method: :delete, form: { data: { turbo_confirm: "Are you sure you want to delete this collection? This action cannot be undone." } }, class: "whitespace-nowrap inline-flex items-center justify-center rounded-md font-medium transition-colors cursor-pointer disabled:pointer-events-none disabled:opacity-50 focus-visible:outline-none focus-visible:ring-1 aria-disabled:pointer-events-none aria-disabled:opacity-50 aria-disabled:cursor-not-allowed px-4 py-2 h-9 text-sm bg-destructive text-white shadow-sm [a&]:hover:bg-destructive/90 focus-visible:ring-destructive/20 dark:focus-visible:ring-destructive/40 dark:bg-destructive/60")
            end
          end
        end
      end
    end
  end
end
