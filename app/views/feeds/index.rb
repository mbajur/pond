module Views
  module Feeds
    class Index < Views::Base
      def initialize(collections: nil, opts: {})
        @collections = collections
        @opts = opts
      end

      def view_template(&)
        Components::PageWrap() do
          div(class: "w-full") do
            render Components::Ui::PageHeader.new do |header|
              header.with_title do
                div(class: "flex gap-2 lg:gap-3 items-center") do
                  RubyUI::Text(as: "h1", size: "2xl", weight: "medium") { a(href: feed_path, class: "") { "Feed" } }
                  plain "•"
                  RubyUI::Text(as: "h1", size: "2xl", weight: "medium") { a(href: discover_path, class: "text-muted-foreground hover:text-foreground") { "Discover" } }
                end
              end

              header.with_primary do
                RubyUI::Text(as: "p", weight: "") { "Collections from people you follow" }
              end
            end

            render RubyUI::Separator.new(class: "my-9")

            if @collections.any?
              @collections.each do |collection|
                render Components::Collections::Collection.new(collection: collection, opts: { show_author: @opts[:show_collection_author] })
              end
            else
              p { "No collections to show. Follow some users to see their collections here!" }
            end
          end
        end
      end
    end
  end
end
