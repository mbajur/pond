module PostSteps
  step ":url URL post by :user on :collection_name collection exists" do |url, user, collection_name|
    user = User.find_by_username!(user)
    collection = Collection.find_by!(name: collection_name, user: user)
    post = create(:post, url: url, user: user)
    create(:pin, collection: collection, user: user, pinable: post)
  end

  step "I click on the :post_title post thumb" do |post_title|
    card = find('div.pin', text: post_title)
    thumb = card.find('a.pin-link')
    thumb.trigger("click")
  end

  step "I should see :post_url post page" do |post_url|
    expect(page).to have_current_path(post_path(Post.find_by!(url: post_url)))
  end
end
