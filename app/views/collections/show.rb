# frozen_string_literal: true

class Views::Collections::Show < Views::Base
  include Phlex::Rails::Helpers::TimeAgoInWords
  include Phlex::Rails::Helpers::Pluralize
  include Phlex::Rails::Helpers::DOMID
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::SimpleFormat

  def initialize(collection:, pins:, pagy:)
    @collection = collection
    @pins = pins
    @pagy = pagy
  end

  def view_template
    Components::PageWrap() do
      div(class: "w-full") do
        render Components::Ui::PageHeader.new do |header|
          header.with_primary do
            simple_format(@collection.description, class: "text-base mb-3")
            RubyUI::Text(as: "p", size: "xs", weight: "muted", class: "mt-4 italic") { meta_info }
          end

          header.with_secondary do
            if @collection.pins_as_pinable.any?
              RubyUI::Text(as: "p", size: "xs", weight: "muted", class: "italic") {
                plain "Pinned in "
                pinned_in_links
              }
            end
          end

          header.with_actions do
            if policy(@collection).connect?
              data = {
                controller: "connect-btn",
                action: "click->connect-btn#openDialog",
                connect_btn_url_value: new_collection_pins_path(@collection)
              }

              Button(data: data, variant: :secondary, size: :sm) { "Connect" }
            end

            if policy(@collection).update?
              Components::Collections::EditBtn(collection: @collection)
            end
          end
        end

        render RubyUI::Separator.new(class: "my-9")

        div(data: { controller: :pagination, pagination_results_id: "inbox-pins", pagination_pagination_id: "pagination" }) do
          div(class: "grid grid-cols-12 gap-4 lg:gap-9", id: "inbox-pins", data: { pagination_target: :results }) do
            @pins.each do |pin|
              div(class: "col-span-6 lg:col-span-3", id: dom_id(pin, :cell)) do
                render Components::Pins::Pin.new(pin: pin)
              end
            end
          end

          div(data: { pagination_target: :pagination }) do
            link_to("Load more", url_for(page: @pagy.next), data: { pagination_target: :link }) if @pagy.next
          end
        end
      end
    end
  end

  private

  def meta_info
    info = []

    info << "private" if @collection.private
    info << "started #{time_ago_in_words(@collection.created_at)} ago"
    info << "updated #{time_ago_in_words(@collection.updated_at)} ago"
    info << "containing #{pluralize(@collection.pins_count, "pin")}"

    info.to_sentence
  end

  def pinned_in_links
    @collection.pins_as_pinable.includes(:collection).map do |post|
      link_to(post.collection.name, user_collection_path(post.collection.user, post.collection))
    end.to_sentence.html_safe
  end
end
