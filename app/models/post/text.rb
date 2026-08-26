class Post::Text < Post
  include Fedipub::DataEntity

  acts_as_fedipub_data handles: "Article",
                       route_path_segment: "posts"

  def to_activitypub_object
    Fedipub::DataTransformer::Article.to_federation self,
                                                    name:    title || "",
                                                    content: content || ""
  end
end
