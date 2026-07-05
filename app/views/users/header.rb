module Views
  module Users
    class Header < Views::Base
      def initialize(user:)
        @user = user
      end

      def view_template(&)
        render Components::Ui::PageHeader.new do |header|
          header.with_primary do
            RubyUI::Text(as: "p", weight: "", class: "mb-4") { @user.description } if @user.description.present?
            render Views::Users::Header::PrimaryMeta.new(user: @user)
          end

          header.with_actions do
            Components::Users::EditBtn(user: @user) if policy(@user).edit?
            Components::FollowBtn(followable: @user) if policy(@user).follow?
          end
        end

        Separator(class: "my-9")
      end
    end
  end
end
