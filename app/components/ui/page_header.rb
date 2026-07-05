module Components
  module Ui
    class PageHeader < Components::Base
      def initialize
        @actions_block = nil
        @primary_block = nil
        @secondary_block = nil
        @tertiary_block = nil
        @title_block = nil
      end

      def view_template(&)
        vanish(&)

        div(id: :page_header) do
          div(class: "flex flex-col lg:flex-row justify-between mb-3 w-full lg:items-center gap-1 lg:gap-3") do
            div { render @title_block || title }
            div(class: "flex items-center gap-2") { @actions_block&.call }
          end

          div(class: "flex gap-3 lg:gap-24 flex-col lg:flex-row") do
            div(class: "lg:w-1/3") { @primary_block&.call } if @primary_block
            div(class: "lg:w-1/3") { @secondary_block&.call } if @secondary_block
            div(class: "lg:w-1/3") { @tertiary_block&.call } if @tertiary_block
          end
        end
      end

      def with_title(&block)
        @title_block = block
        nil
      end

      def with_actions(&block)
        @actions_block = block
        nil
      end

      def with_primary(&block)
        @primary_block = block
        nil
      end

      def with_secondary(&block)
        @secondary_block = block
        nil
      end

      def with_tertiary(&block)
        @tertiary_block = block
        nil
      end

      private

      def title
        Ui::CurrentBreadcrumbs.new
      end
    end
  end
end
