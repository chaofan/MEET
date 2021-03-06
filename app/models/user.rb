class User < ActiveRecord::Base
  has_many	:blogs
  has_many  :forum_posts
  has_one   :profile, :dependent=>:destroy
  has_many  :collects
  has_many  :collected_courses, :through=>:collects, :source=>:course
  has_many  :owned_courses, :foreign_key=>"author_id"

  has_many  :topics
  has_many  :comments

  has_many :friendships
  has_many :friends, :through => :friendships

  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"      
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user  

  before_create :create_profile
  devise :database_authenticatable, :rememberable, :trackable, :validatable, :registerable	
  has_many :assignments
  has_many  :roles, :through=>:assignments

  with_options :class_name => "Message", :dependent => :destroy,
    :order => 'created_at DESC' do |user|
    user.has_many :_sent_messages, :foreign_key => "sender_id",
      :conditions => "sender_deleted_at IS NULL"
    user.has_many :_received_messages, :foreign_key => "recipient_id",
      :conditions => "recipient_deleted_at IS NULL"
    end

  # 定义一些常用的变量
  TRASH_TIME_AGO = 1.month.ago
  MESSAGES_PER_PAGE = 5
  NUM_RECENT_MESSAGES = 4

  def role_symbols  
    roles.map do |role|
      role.name.underscore.to_sym  
    end  
  end  

  ## Message methods
  def received_messages(page = 1)
    _received_messages.paginate(:page => page, :per_page => MESSAGES_PER_PAGE)
  end

  def sent_messages(page = 1)
    _sent_messages.paginate(:page => page, :per_page => MESSAGES_PER_PAGE)
  end

  def trashed_messages(page = 1)
    conditions = [%((sender_id = :person AND sender_deleted_at > :t) OR
                    (recipient_id = :person AND recipient_deleted_at > :t)),
                    { :person => id, :t => TRASH_TIME_AGO }]
                    order = 'created_at DESC'
                    trashed = Message.paginate(:all, :conditions => conditions,
                                               :order => order,
                                               :page => page,
                                               :per_page => MESSAGES_PER_PAGE)
  end

  def recent_messages
    Message.find(:all,
                 :conditions => [%(recipient_id = ? AND
                                   recipient_deleted_at IS NULL), id],
                                   :order => "created_at DESC",
                                   :limit => NUM_RECENT_MESSAGES)
  end

  protected
  def create_profile
    self.profile ||= Profile.new
  end

end



# == Schema Information
#
# Table name: users
#
#  id                  :integer         not null, primary key
#  email               :string(255)     default(""), not null
#  encrypted_password  :string(128)     default(""), not null
#  password_salt       :string(255)     default(""), not null
#  remember_token      :string(255)
#  remember_created_at :datetime
#  sign_in_count       :integer         default(0)
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :string(255)
#  last_sign_in_ip     :string(255)
#  blogs_count         :integer         default(0)
#  created_at          :datetime
#  updated_at          :datetime
#  gold                :integer         default(0)
#  score               :integer         default(0)
#  answers             :integer         default(0)
#

