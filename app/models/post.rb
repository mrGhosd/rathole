class Post < ActiveRecord::Base
  include Authority::Abilities
  
  self.authorizer = PostAuthorizer

  validates :title, presence: true
  validates :section, presence: true

  belongs_to :user, counter_cache: true
  belongs_to :section, counter_cache: true

  has_many :comments

  delegate :user_name, to: :user, prefix: false
  delegate :avatar_url, to: :user, prefix: true

  acts_as_taggable_on :tags

  scope :in_order, -> { order('posts.created_at DESC') }

  def preview(lines = 2)
    body.split("\r\n\r\n").first(lines).join("\r\n\r\n")
  end
end