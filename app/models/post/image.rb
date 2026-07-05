class Post::Image < Post
  AVAILABLE_CONTENT_TYPES = %w[image/png image/jpeg image/gif].freeze

  has_many_attached :files do |attachable|
    attachable.variant :square_350, resize_to_fit: [ 350, 350 ], format: :jpg, saver: { quality: 80 }, preprocessed: true
  end

  validates :files, attached: true
  validates :files, limit: { max: 1 }
  validates :files, processable_file: true
  validates :files, size: { less_than: 2.megabytes }
  validates :files, content_type: { in: AVAILABLE_CONTENT_TYPES, spoofing_protection: true }
end
