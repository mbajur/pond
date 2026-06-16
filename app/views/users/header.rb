module Views
  module Users
    class Header < Views::Base
      def initialize(user:)
        @user = user
      end

      def view_template(&)
        render Components::Ui::PageHeader.new do |header|
          header.with_primary do
            div(class: "[&_p]:text-base [&_p]:mb-4") do
              marksmithed_minimal(@user.description)
            end if @user.description.present?

            render Views::Users::Header::PrimaryMeta.new(user: @user)
          end

          header.with_actions do
            Components::Users::EditBtn(user: @user) if policy(@user).edit?
            Components::Users::FollowBtn(user: @user) if policy(@user).follow?
          end
        end

        Separator(class: "my-9")
      end
    end
  end
end
