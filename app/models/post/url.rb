class Post::Url < Post
  validates_url :url, presence: true, schemes: [ :http, :https ]

  # Moved to Post so we can join it during searches. Not ideal but it works for now.
  # has_one_attached :screenshot do |attachable|
  #   attachable.variant :square_350, resize_to_fit: [ 350, 350 ], format: :jpg, saver: { quality: 80 }, preprocessed: true
  # end
end
