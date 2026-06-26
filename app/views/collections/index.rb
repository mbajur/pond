# frozen_string_literal: true

class Views::Collections::Index < Views::Base
  def initialize(collections:, inbox:, user:)
    @inbox = inbox
    @collections = collections
    @user = user
  end

  def view_template
    Components::PageWrap() do
      div(class: "w-full") do
        render Views::Users::Header.new(user: @user)

        render Components::Collections::Collection.new(collection: @inbox) if @inbox

        @collections.each do |collection|
          render Components::Collections::Collection.new(collection: collection)
        end

        if policy(@user).add_collection?
          render Components::Collections::AddBtn.new(collection: Collection.new)
        end
      end
    end
  end
end
