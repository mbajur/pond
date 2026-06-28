module Components
  module Collections
    class Collection < Components::Base
      include Phlex::Rails::Helpers::DOMID
      include Phlex::Rails::Helpers::SimpleFormat

      def initialize(collection:, opts: {})
        @id = opts[:id]
        @collection = collection
        @presented_collection = CollectionPresenter.new(@collection)
        @opts = opts
      end

      def view_template(&)
        cache(@collection) do
          div(class: "mb-6", id: @id || dom_id(@collection)) do
            div(class: "grid grid-cols-12 gap-4 lg:gap-9 w-full") do
              div(class: "col-span-12 lg:col-span-3") do
                a(href: href, class: "hover:underline") do
                  render RubyUI::Heading(level: 4, class: "inline") { @presented_collection.name }
                end

                span(class: "text-muted-foreground font-normal ml-1 text-sm italic", title: "Private") {
                  "(p)"
                } if @collection.private

                simple_format(@collection.description, class: "text-sm font-normal mt-2")

                Text(size: "1", class: "text-muted-foreground mt-3 italic") do
                  meta_info
                end
              end

              div(class: "col-span-12 lg:col-span-9 flex gap-6") do
                div(class: "grid grid-cols-12 gap-4 lg:gap-9 w-full") do
                  @collection.pins.newest_first.includes(:user, pinable: [ :screenshot_attachment, :thumb_attachment ]).limit(4).each do |pin|
                    div(class: "col-span-6 lg:col-span-3") do
                      render Components::Pins::Pin(pin: pin)
                    end
                  end
                end
              end
            end

            Separator(class: "mt-6 mb-9")
          end
        end
      end

      private

      def href
        user_collection_path(@collection.user, @collection)
      end

      def meta_info
        return nil if @collection.inbox?

        Components::Collections::MetaInfo(collection: @collection, opts: @opts)
      end
    end
  end
end
