module ProfileSteps
  step "I visit :username profile page" do |username|
    visit user_path(username)
  end

  step "I should see :button button" do |button|
    expect(page).to have_button(button)
  end

  step "I should see :text in profile header" do |text|
    within("#page-header") do
      expect(page).to have_content(text)
    end
  end
end
