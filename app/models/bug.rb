class Bug < ActiveRecord::Base
  belongs_to :reporter, class_name: 'User'
  belongs_to :post

  validates :reporter, presence: true
  validates :post, presence: true

  enum state: [ :open, :fixed, :rejected ]

  include Authority::Abilities
  
  include Redcarpeted

  redcarpet :note
  redcarpet :fragment

  scope :in_order, -> { order('bugs.created_at DESC') }
  scope :for_author, -> (user) { joins(:post).where(posts: {user_id: user.id}) }
  scope :for_reporter, -> (user) { where(bugs: {reporter_id: user.id}) }

  delegate :user_name, to: :reporter, prefix: true
  delegate :title, to: :post, prefix: true

  after_create :fire_bug_created_event!

  def has_fragment?
    fragment.present?
  end

  def fix
    self.state = :fixed
    saved = self.save
    fire_bug_fixed_event! if saved
    saved
  end

  def reject
    self.state = :rejected
    saved = self.save
    fire_bug_rejected_event! if saved
    saved
  end

  private

  def fire_bug_created_event!
    event = Events::BugCreatedEvent.new
    event.bug = self
    event.reporter = reporter
    event.post = post
    event.author = post.user
    event.save!
  end

  def fire_bug_fixed_event!
    event = Events::BugFixedEvent.new
    event.bug = self
    event.reporter = reporter
    event.post = post
    event.author = post.user
    event.save!
  end

  def fire_bug_rejected_event!
    event = Events::BugRejectedEvent.new
    event.bug = self
    event.reporter = reporter
    event.post = post
    event.author = post.user
    event.save!
  end
end