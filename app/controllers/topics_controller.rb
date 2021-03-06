class TopicsController < ApplicationController
  respond_to :html, :js

  def index
    @forums = Forum.find(:all)
    @forum = Forum.find(params[:forum_id])
    @topics = @forum.topics.paginate(:page => params[:page], :per_page=>8, :order => 'updated_at DESC')

    respond_with(@topics)
  end

  def new
    @forums = Forum.find(:all)
    @forum = Forum.find(params[:forum_id])
    @topic = @forum.topics.build()
  end

  def show
    @forums = Forum.find(:all)
    @forum = Forum.find(params[:forum_id])
    @topic = @forum.topics.find(params[:id])
    @topic.views = @topic.views + 1
    @topic.save
    
    respond_with(@forum, @topic)
  end

  def edit
    @forums = Forum.find(:all)
    @forum = Forum.find(params[:forum_id])
    @topic = @forum.topics.find(params[:id])

    respond_with(@forum, @topic) 
  end

  def create
    @forum = Forum.find(params[:forum_id])
    @topic = @forum.topics.build(params[:topic])
    @topic.user = current_user
    if @topic.save
      respond_with([@forum,@topic])
    else
      redirect_to forum_topic_path(@forum, @topic, :notice=>"save failed")
    end
  end


  def update
    @forum = Forum.find(params[:forum_id])
    @topic = Topic.find(params[:id])
    if @topic.update_attributes(params[:topic])
      redirect_to forum_topic_path(@forum, @topic, :notice=>"update succeed")
    else
      render edit_forum_topic_path(@forum, @topic, :error=>"update failed")
    end
  end

  # 需要做动态的效果来实现
  def destroy
    @forum = Forum.find(params[:forum_id])
    @topic = @forum.topics.find(params[:id])

    if @forum.topics.destroy(@topic)
      redirect_to forum_path(@forum, :notice=>"delete succeed")
    else
      redirect_to forum_path(@forum, :error=>"delete failed")
    end
  end

end
