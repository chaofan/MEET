class FriendshipsController < ApplicationController
  include ApplicationHelper
  #before_filter :authorize_user, :only => [:edit, :update, :destroy, :accept, :decline]

  #before_filter :login_required, :setup
  before_filter :authorize_view, :only => :index
  before_filter :authorize_user, :only => [:edit, :update, :destroy]
  before_filter :redirect_for_inactive, :only => [:edit, :update]

  # Show all the contacts for a person.
  def index
    @friends = @user.friends.paginate(:page => params[:page],
                                      :per_page => RASTER_PER_PAGE)
  end

  def show
    # We never use this, but render "" for the bots' sake.
    render :text => ""
  end

  def edit
    @friend = @friendship.friend
  end

  def create 
    @user = User.find(params[:friend_id])
    if Friendship.request(current_user, @user) 
      flash[:notice] =  'Connection request sent!'
    else      
      flash[:notice] = "Invalid connection"
    end      

    redirect_to people_path
  end

  def destroy
    logger.info("-------destroy-------------")
    @friendship.breakup

    flash[:success] = "Ended connection with #{@friendship.friend.profile.name}"
    redirect_to people_path
  end  

  def update
    friend = @friendship.friend
    name = friend.profile.name
    case params[:commit]
    when "Accept"
      logger.debug("------------------------------Accept")
      @friendship.accept
      flash[:notice] = "Accepted connection with #{name}"
    when "Decline"
      logger.info("-------------------------------Decline")
      @friendship.breakup
      flash[:notice] = "Declined connection with #{name}"
    end

    redirect_to people_path
  end 

  private

  def setup
    # Connections have same body class as profiles.
    @body = "profile"
  end

  def authorize_view
    @user = User.find(params[:user_id])
    unless (current_user?(@user) or
            Friendship.connected?(@user, current_user))
            redirect_to root_url
    end
  end

  # Make sure the current person is correct for this connection.
  def authorize_user
    @friendship = Friendship.find(params[:id], :include => [:user])
    logger.error("Friendship is #{@friendship.inspect}")
    unless current_user?(@friendship.user)
      flash[:error] = "Invalid connection."
      redirect_to people_path
    end
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Invalid or expired connection request"
    redirect_to people_path
  end


  # Redirect if the target person is inactive.
  # Suppose Alice sends Bob a connection request, but then the admin 
  # deactivates Alice.  We don't want Bob to be able to make the connection.
  def redirect_for_inactive
    #if @friendship.friend.deactivated?
    #  flash[:error] = "Invalid connection request: person deactivated"
    #  redirect_to people_url
    #end
  end
end
