require 'activity_logger'

class Friendship < ActiveRecord::Base
  include ActivityLogger

  belongs_to :user
  belongs_to :friend, :class_name => 'User'    

  after_create :log_activity
  
  has_many :activities, :foreign_key => "item_id", :dependent => :destroy,
                        :conditions => "item_type = 'Friendship'"
  validates_presence_of :user_id, :friend_id

  def log_activity
    activity = Activity.create!(:item => self, :user => user)
    add_activities(:activity => activity, :user => user)
  end

  # Status codes.
  ACCEPTED  = 0
  REQUESTED = 1
  PENDING   = 2

  # Accept a connection request (instance method).
  # Each connection is really two rows, so delegate this method
  # to Friendship.accept to wrap the whole thing in a transaction.
  def accept
    Friendship.accept(user_id, friend_id)
  end

  def breakup
    Friendship.breakup(user_id, friend_id)
  end

  class << self
    # Return true if the users are (possibly pending) connections.
    def exists?(user, friend)
      not conn(user, friend).nil?
    end

    alias exist? exists?

    # Make a pending connection request.
    def request(user, friend)
      if user == friend or Friendship.exists?(user, friend)
        nil
      else
        transaction do
          create(:user => user, :friend => friend, :status => PENDING)
          create(:user => friend, :friend => user, :status => REQUESTED)
        end
        true
      end
    end

    # Accept a connection request.
    def accept(user, friend)
      transaction do
        accepted_at = Time.now
        accept_one_side(user, friend, accepted_at)
        accept_one_side(friend, user, accepted_at)
      end
      # Exclude the first admin to prevent everyone's feed from
      # filling up with new registrants.
      #unless [user, friend].include?(User.find_first_admin)
      #  log_activity(conn(user, friend))
      #end
    end

    def connect(user, friend)
      transaction do
        request(user, friend)
        accept(user, friend)
      end
      conn(user, friend)
    end

    # Delete a connection or cancel a pending request.
    def breakup(user, friend)
      logger.info("breakup #{user} #{friend}")
      transaction do
        destroy(conn(user, friend))
        destroy(conn(friend, user))
      end
    end

    # Return a connection based on the user and friend.
    def conn(user, friend)
      find_by_user_id_and_friend_id(user, friend)
    end

    def accepted?(user, friend)
      conn(user, friend).status == ACCEPTED
    end

    def connected?(user, friend)
      exist?(user, friend) and accepted?(user, friend)
    end

    def pending?(user, friend)
      logger.info("--------------------pending")
      logger.info("#{user.id} #{friend.id}")
      exist?(user, friend) and conn(friend,user).status == PENDING
    end
  end

  private

  class << self
    # Update the db with one side of an accepted connection request.
    def accept_one_side(user, friend, accepted_at)
      conn = conn(user, friend)
      conn.update_attributes!(:status => ACCEPTED,
                              :accepted_at => accepted_at)
    end

    def log_activity(conn)
      activity = Activity.create!(:item => conn, :user => conn.user)
      add_activities(:activity => activity, :user => conn.user)
      add_activities(:activity => activity, :user => conn.friend)
    end
  end
end


# == Schema Information
#
# Table name: friendships
#
#  id          :integer         not null, primary key
#  user_id     :integer
#  friend_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#  status      :integer
#  accepted_at :datetime
#

