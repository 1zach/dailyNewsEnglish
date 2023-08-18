class BlogPostsController < ApplicationController
  before_action :set_blog_post, only: [:show, :update, :edit, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  
  rescue_from Pagy::OverflowError, with: :redirect_to_last_page


  def index
    @blogposts = user_signed_in? ? BlogPost.all.sorted : BlogPost.published.sorted
    @pagy, @blogposts = pagy(@blogposts)
  end

  def show

  end

  def new
    @blog_post = BlogPost.new
  end

  def create
    @blog_post = BlogPost.new(blogpost_params)
    if @blog_post.save
      redirect_to @blog_post
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
      if (@blog_post.update(blogpost_params))
        redirect_to @blog_post
      else
        render :edit, status: :unprocessable_entity
      end
  end

  def destroy
    @blog_post.destroy
      redirect_to root_path
  end

  private

  def blogpost_params
    params.require(:blog_post).permit(:title, :content, :published_at)
  end

  def set_blog_post
    @blog_post = user_signed_in? ? BlogPost.find(params[:id]) : BlogPost.published.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def redirect_to_last_page(exception)
    redirect_to url_for(page: exception.pagy.last), notice: "Page ##{params[:page]} is overflowing. Showing page #{exception.pagy.last} instead."
   end

end
