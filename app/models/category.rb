class Category < ActiveRecord::Base
	has_many	:courses
end

# == Schema Information
#
# Table name: categories
#
#  id         :integer         not null, primary key
#  name       :string(12)
#  created_at :datetime
#  updated_at :datetime
#

