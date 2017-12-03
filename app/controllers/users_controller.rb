class UsersController < ApplicationController
# before_action :correct_user only:[:edit, :update, :delete]


  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(created_at: :desc)
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "ようこそ the Sample App へ！!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    unless @user.id == session[:user_id] then
      flash[:danger] = "不正な入力です"
      redirect_to current_user
    end
  end
  
  def update
    
    @user = User.find(params[:id])

    if @user.id == current_user.id
      if (!@user.authenticate(params[:user][:cur_password]))
        flash[:danger] = '現在のパスワードに誤りがあります'
        render 'edit'
      elsif @user.update_attributes(user_params)
        flash[:success] = "情報を更新しました"
        redirect_to current_user
      else
        # フォームのエラーメッセージと重複するので、メッセージは割愛
        render 'edit'
      end
    else
      flash[:danger] = "不正な入力です"
      redirect_to @user
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :locate, :profile,
                                 :password_confirmation)
  end
  
  def correct_user
    @user = User.find(params[:id])
    if (current_user != @user)
      redirect_to root_url
    end
  end
  
end
