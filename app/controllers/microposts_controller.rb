class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy


  def create
  @micropost = current_user.microposts.build(micropost_params)
  
  # 에러 발생시
  #  $ sudo apt-get update
  # $ sudo apt-get install imagemagick --fix-missing
    if @micropost.save
      flash[:success] = "게시글이 등록되었습니다.!"
      redirect_to blog_path
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "게시글이 삭제 되었습니다."
    redirect_to blog_path
  end

  def new
    @micropost = Micropost.new
  end

  
  def like
   @micropost = Micropost.find(params[:id])
   @micropost.likes.create
   redirect_back_or root_path

  end

  private
  def micropost_params
      params.require(:micropost).permit(:title, :content, :picture)
    end

     def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

end
