class Views::Searches::Show < Views::Base
  include Phlex::Rails::Helpers::Pluralize
  include Phlex::Rails::Helpers::Debug

  def initialize(query:, collections:, posts:)
    @query = query
    @collections = collections
    @posts = posts
  end

  def view_template(&)
    Components::PageWrap() do
      div(class: "w-full") do
        render Components::Ui::PageHeader.new do |header|
          header.with_primary do
            RubyUI::Text(as: "p", size: "xs", weight: "muted", class: "mt-4 italic") { "#{pluralize @collections.count + @posts.count, 'result'} found" }
          end
        end

        render RubyUI::Separator.new(class: "my-9")

        @collections.each do |collection|
          render Components::Collections::Collection.new(collection: collection)
        end

        div(class: "mt-26 grid grid-cols-12 gap-4 lg:gap-9", id: "inbox-pins", data: { pagination_target: :results }) do
          @posts.each do |post|
            div(class: "col-span-6 lg:col-span-3") do
              if post.is_a?(Post::Url)
                render Components::Posts::Url::Card.new(post: post)
              elsif post.is_a?(Post::Text)
                render Components::Posts::Text::Card.new(post: post)
              elsif post.is_a?(Post::Image)
                render Components::Posts::Image::Card.new(post: post)
              else
                raise "Unknown post type: #{post.class.name}"
              end
            end
          end
        end
      end
    end
  end
end
