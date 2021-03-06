class PostsController < ApplicationController  
  before_action :store_current_url_in_session, :only => [:index, :show]
  before_action :authenticate_user!, :except => [:index, :show]
  
  before_action :load_user, :only => [:index, :show]
  before_action :load_posts, :only => [:index, :show]
  before_action :load_sections, :only => [:new, :create, :edit, :update]

  def index
    @posts = @posts.tagged_with(params[:tag]) if params[:tag].present?
    unless @user
      @posts = @posts.visible_on_main 
    end
    @posts = @posts.in_order
    @posts = @posts.page(params[:page]).per(params[:per])
  end

  def show
    @post = @posts.find(params[:id])
    authorize! :show, @post
    @comments = @post.comments
    @comments = @comments.includes(:user)
    @comments = @comments.in_order
    @comments = @comments.page(1).per(params[:per])
  end

  def new
    authorize! :new, Post
    @post = current_user.posts.build
  end

  def create
    authorize! :create, Post
    @post = current_user.posts.build(post_params)
    @post.section = @section
    if @post.save
      flash[:notice] = I18n.t('posts.create.success') 
      redirect_to user_post_path(@post)
    else
      @pictures = current_user.pictures
      render :new
    end
  end

  def edit
    @post = current_user.posts.find(params[:id])
    authorize! :edit, @post
  end

  def update
    @post = current_user.posts.find(params[:id])
    authorize! :update, @post
    @post.attributes = post_params
    @post.section = @section
    if @post.save
      flash[:notice] = I18n.t('posts.update.success') 
      redirect_to user_post_path(@post)
    else
      @pictures = current_user.pictures
      render :edit
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    authorize! :destroy, @post
    if @post.destroy
      flash[:notice] = I18n.t('posts.destroy.success')
      redirect_to user_posts_index_path(:user_name => current_user.user_name)
    else
      flash[:error] = @section.errors[:base].any? ? @section.errors[:base].join : I18n.t('posts.destroy.failed')
      redirect_to :back
    end
  end

  def publish
    @post = current_user.posts.find(params[:id])
    authorize! :update, @post
    if @post.toggle
      flash[:notice] = I18n.t("posts.publish.#{@post.state}.success")
    else
      flash[:error] =  I18n.t("posts.publish.#{@post.state}.failed")
    end
    redirect_to user_post_path(@post)
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :tag_list)
  end

  def load_user
    if params[:user_name].present?
      @user = User.find_by(user_name: params[:user_name])
      @user || not_found
    end
  end

  def load_posts
    @posts = @user.present? ? @user.posts : Post.all
    @posts = @posts.accessible_by(current_ability)
    @posts = @posts.joins(:section).where(section_id: params[:section_id]) if params[:section_id].present?
  end

  def load_sections 
    @sections = current_user.sections
    @section = @sections.find(params[:post][:section_id]) if params[:post].present? && params[:post][:section_id].present?
  end
end
