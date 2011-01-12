class ForumTopicsController < ApplicationController
  respond_to :html, :xml, :json
  before_filter :member_only, :except => [:index, :show]
  rescue_from User::PrivilegeError, :with => "static/access_denied"

  def new
    @forum_topic = ForumTopic.new
    respond_with(@forum_topic)
  end
  
  def edit
    @forum_topic = ForumTopic.find(params[:id])
    check_privilege(@forum_topic)
    respond_with(@forum_topic)
  end
  
  def index
    @search = ForumTopic.search(params[:search])
    @forum_topics = @search.paginate(:page => params[:page], :order => "updated_at DESC")
    respond_with(@forum_topics)
  end
  
  def show
    @forum_topic = ForumTopic.find(params[:id])
    respond_with(@forum_topic)
  end
  
  def create
    @forum_topic = ForumTopic.create(params[:forum_topic])
    respond_with(@forum_topic)
  end
  
  def update
    @forum_topic = ForumTopic.find(params[:id])
    check_privilege(@forum_topic)
    @forum_topic.update_attributes(params[:forum_topic])
    respond_with(@forum_topic)
  end
  
  def destroy
    @forum_topic = ForumTopic.find(params[:id])
    check_privilege(@forum_topic)
    @forum_topic.destroy
    respond_with(@forum_topic)
  end
  
  private
    def check_privilege(forum_topic)
      if !forum_topic.editable_by?(CurrentUser.user)
        raise User::PrivilegeError
      end
    end
end
