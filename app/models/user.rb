class User < ActiveRecord::Base
  has_many	:blogs
  has_many    :forum_posts
  has_one     :profile
  has_many    :collects
  has_many    :collected_courses, :through=>:collects, :source=>:course
  has_many    :owned_courses, :foreign_key=>"author_id"

  has_many :friendships      
  has_many :friends, :through => :friendships      

  before_save :add_profile
  devise :database_authenticatable, :rememberable, :trackable, :validatable, :registerable	

  def add_profile
    self.profile = Profile.new()
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
#  role_id             :integer
#

