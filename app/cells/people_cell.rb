class PeopleCell < Cell::Rails
  helper  ApplicationHelper

  def message_board
    render
  end

  def network_activity
    render
  end

  def friends
    @user = @opts[:user]
    @current_user = @opts[:current_user]

    render
  end

  def friends_birthday
    @user = @opts[:user]
    @current_user = @opts[:current_user]

    render
  end
  
  def added_groups
    @user = @opts[:user]
    @current_user = @opts[:current_user]

    render
  end

  def promotional
    @user = @opts[:user]
    @current_user = @opts[:current_user]

    render
  end

  def recent_visits
    @user = @opts[:user]
    @current_user = @opts[:current_user]

    render
  end

  def message_center
    @user = @opts[:user]
    @current_user = @opts[:current_user]

    render
  end

  def other_people
    @user = @opts[:user]
    @current_user = @opts[:current_user]

    render
  end

  def personal_setting
    @user = @opts[:user]
    @current_user = @opts[:current_user]

    render
  end

  def current_people
    @user = @opts[:user]
    @current_user = @opts[:current_user]

    render
  end

  def personal_info
    @user = @opts[:user]
    @current_user = @opts[:current_user]

    render
  end

  def all_people
    @current_user = @opts[:current_user]
    @users = User.find(:all)

    render
  end

  def connected_friends
    @current_user = @opts[:current_user]
    @connected_friends = Friendship.where("user_id=? and status=?", @current_user, Friendship::ACCEPTED)

    render
  end

  def requested_friends
    @current_user = @opts[:current_user]
    @requested_friends = Friendship.where("user_id=? and status=?", @current_user, Friendship::REQUESTED)

    render
  end

  def pending_friends
    @current_user = @opts[:current_user]
    @pending_friends = Friendship.where("user_id=? and status=?", @current_user, Friendship::PENDING)

    render
  end
end
