module MiscSteps
  step "I click on the :button button" do |button|
    click_button button
  end

  step "I click on the :link link" do |link|
    click_link link
  end

  step "I fill in :field with :value" do |field, value|
    fill_in field, with: value
  end

  step "I check :checkbox checkbox" do |checkbox|
    check checkbox, allow_label_click: true
  end

  step "I should not see :button button" do |button|
    expect(page).not_to have_button(button)
  end

  step "I should see :text text" do |text|
    expect(page).to have_content(text)
  end

  step "I should not see :text text" do |text|
    expect(page).not_to have_content(text)
  end

  step "I should see :message flash message" do |message|
    expect(page).to have_content(message)
  end

  step "I should see :text in page header" do |text|
    within("#page-header") do
      expect(page).to have_content(text)
    end
  end

  step "I should be on :path path" do |path|
    expect(page).to have_current_path(path)
  end
end
