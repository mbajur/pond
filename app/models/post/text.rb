class Post::Text < Post
  include Fedipub::DataEntity

  acts_as_fedipub_data handles: "Article"
end
