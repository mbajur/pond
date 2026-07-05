module FeedSteps
  step "I visit feed page" do
    visit feed_path
  end

  step "I should see :name in the feed" do |name|
    expect(page).to have_content(name)
  end

  step "I should not see :name in the feed" do |name|
    expect(page).not_to have_content(name)
  end
end
