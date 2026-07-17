module PostSteps
  step ":url URL post by :user on :collection_name collection exists" do |url, user, collection_name|
    user = User.find_by_username!(user)
    collection = Collection.find_by!(name: collection_name, user: user)
    post = create(:post, url: url, user: user)
    create(:pin, collection: collection, user: user, pinable: post)
  end

  step ":image image post by :user on :collection_name collection exists" do |image, user, collection_name|
    user = User.find_by_username!(user)
    collection = Collection.find_by!(name: collection_name, user: user)
    post = create(:post, :image, user: user, title: image)
    post.becomes(Post::Image).files.attach(io: File.open(Rails.root.join("spec/fixtures/files/#{image}")), filename: image)
    create(:pin, collection: collection, user: user, pinable: post)
  end

  step ":content text post by :user on :collection_name collection exists" do |content, user, collection_name|
    user = User.find_by_username!(user)
    collection = Collection.find_by!(name: collection_name, user: user)
    post = create(:post, :text, user: user, content: content)
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

  step ":url pinned URL post is updated with :title" do |url, title|
    post = Post.find_by!(url: url)
    post.update!(title: title)
    post.refresh_pins_cards
  end

  step "I should be on a post page with :post_title title" do |post_title|
    post = Post.find_by!(title: post_title)
    expect(page).to have_current_path(post_path(post))
  end
end
