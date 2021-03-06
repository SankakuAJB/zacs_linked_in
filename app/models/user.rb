class User < ActiveRecord::Base


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

    validates :name, presence: true
    validates :phone, presence: true

    has_many :skills
    has_many :employees

    # Following Relationships
    has_many :active_relationships, class_name: "Relationship",
                                   foreign_key: "follower_id",
                                     dependent: :destroy
    has_many :following, through: :active_relationships, source: :followed
    has_many :passive_relationships, class_name: "Relationship",
                                    foreign_key: "followed_id",
                                      dependent: :destroy
    has_many :followers, through: :passive_relationships, source: :follower

    # Person to Person Endorsements
    has_many :active_endorsements, class_name: "Endorsement",
                                  foreign_key: "endorser_id",
                                    dependent: :destroy
    has_many :endorsed, through: :active_endorsements, source: :endorser
    has_many :passive_endorsements, class_name: "Endorsement",
                                   foreign_key: "user_id",
                                     dependent: :destroy
    has_many :endorsements, through: :passive_endorsements, source: :user

    # Comments
    has_many :comments
    has_many :active_comments, class_name: "Comment",
                              foreign_key: "commented_id",
                                dependent: :destroy
    has_many :commenter, through: :active_comments, source: :commenter


  # Follows a user.
  def follow(other_user)
  	active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user
  def unfollow(other_user)
  	active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
  	following.include?(other_user)
  end

  # Endorses a User/Employee/Skill
  def endorse(current_user, other_user)
    active_endorsements.create(endorser_id: current_user.id, user_id: other_user.id)
  end

  # Unendorse a user.
  def unendorse(other_user)
    active_endorsements.find_by(user_id: other_user.id).destroy
  end

  # Returns true if the current user endorses the other user.
  def endorsing?(other_user)
    endorsed.include?(other_user)
  end

end
