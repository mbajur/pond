class Collection < ApplicationRecord
  include Slugable
  include SearchCop

  has_many :pins, dependent: :destroy
  has_many :pins_as_pinable, class_name: "Pin", as: :pinable, dependent: :destroy
  belongs_to :user

  before_validation :ensure_changed_at

  validates :name, presence: true
  validate :only_one_inbox_per_user, if: :inbox?

  scope :inbox, -> { where(inbox: true) }
  scope :regular, -> { where(inbox: false) }
  scope :recently_changed_first, -> { order(changed_at: :desc) }

  search_scope :search do
    attributes :name, user: "user.username"
  end

  def self.find_inbox!
    find_by!(inbox: true)
  end

  def self.find_inbox
    find_by(inbox: true)
  end

  def to_s
    name
  end

  def to_meta_tags
    {
      title: name,
      description: description
    }
  end

  private

  def only_one_inbox_per_user
    if inbox? && user.collections.inbox.where.not(id: id).exists?
      errors.add(:inbox, "can only have one inbox collection per user")
    end
  end

  def ensure_changed_at
    self.changed_at ||= Time.current
  end
end
