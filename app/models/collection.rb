class Collection < ApplicationRecord
  include Fedipub::ActorEntity
  include Slugable
  include SearchCop

  has_many :pins, dependent: :destroy
  has_many :pins_as_pinable, class_name: "Pin", as: :pinable, dependent: :destroy
  belongs_to :user
  has_many :fedipub_moderators_join, class_name: "Fedipub::Moderator", as: :entity
  has_many :fedipub_moderators, class_name: "Fedipub::Actor", through: :fedipub_moderators_join, source: :actor

  before_validation :ensure_changed_at
  after_create :create_fedipub_moderator

  validates :name, presence: true
  validates :username, uniqueness: true, allow_nil: true
  validate :only_one_inbox_per_user, if: :inbox?

  scope :inbox, -> { where(inbox: true) }
  scope :regular, -> { where(inbox: false) }
  scope :recently_changed_first, -> { order(changed_at: :desc) }

  search_scope :search do
    attributes :name, user: "user.username"
  end

  acts_as_fedipub_actor username_field: :username,
                        name_field: :name,
                        profile_url_method: :collection_url

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

  def refresh_rows_later
    broadcast_replace_later_to(self, target: "row_collection_#{id}", html: ApplicationController.render(Components::Collections::Collection.new(collection: self), layout: false))
  end

  def generate_username
    self.username ||= [slug, "pond"].join("-") if slug.present?
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

  def create_fedipub_moderator
    fedipub_moderators_join.create!(actor: user.fedipub_actor)
  end
end
