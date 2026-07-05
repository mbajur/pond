module ConnectionSteps
  step "I visit :collection_name collection by :user" do |collection_name, user|
    user = User.find_by_username!(user)
    collection = Collection.find_by!(name: collection_name, user: user)
    visit user_collection_path(user, collection)
  end

  step "I click :button button within :post_title post connection" do |button, post_title|
    card = find('div.pin', text: post_title)
    card.hover
    within(card) do
      click_button(button)
    end
  end

  step "I should see :post_title post connection" do |post_title|
    find('body').hover # just to make sure pin is not in hover state
    expect(page).to have_selector('div.pin', text: post_title)
  end
end
