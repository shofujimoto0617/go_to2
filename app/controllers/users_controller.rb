class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]
  def show
	  @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: "DESC")

    # @current_entry = Entry.where(user_id: current_user.id)
    # room_ids = @current_entry.pluck(:room_id)
    # @another_entry = Entry.where(user_id: @user.id)
    # another_entry_room_ids = @another_entry.where(room_id: room_ids).pluck(:room_id)

    # unless @user.id == current_user.id
    #   if another_entry_room_ids.length > 0
    #         @is_room = true
    #         @room_id = room_id[0]
    #   else
    #     @room = Room.new
    #     @entry = Entry.new
    #   end
    # end

    @current_entry = Entry.where(user_id: current_user.id)
    @another_entry = Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      @current_entry.each do |current|
        @another_entry.each do |another|
          if current.room_id == another.room_id
            @is_room = true
            @room_id = current.room_id
          end
        end
      end
      unless @is_room
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def show_country
    @user = User.find(params[:id])
    # linkから受け取る値(all/0/1)で条件分岐
    if params[:country] == "all"
      @posts = @user.posts.order(created_at: "DESC")
    else
      @posts = @user.posts.where(country: params[:country]).order(created_at: "DESC")
    end
  end

  def edit
  	@user = User.find(params[:id])
    # ラジオボタンにチェックしていればtrue/チェックなければfalse
    @man = @user.sex == "男性" ? true : false
    @femalu = @user.sex == "女性" ? true : false
  end

  def update
  	@user = User.find(params[:id])
    # date型に変換
    data = user_params
    data[:sex] = data[:sex].to_i

    if @user.email == "test@example.com"
      redirect_to edit_user_path(@user.id), notice: "* Cannot be edited because it is a guest user"
  	elsif @user.update(data)
  	  redirect_to user_path(@user.id), notice: "* Editing is complete"
  	else
  	  render "edit"
  	end
  end

  def following
    @user = User.find(params[:id])
    @users = @user.following_user
    render 'show_following'
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.follower_user
    render 'show_follower'
  end

  private
  def user_params
  	params.require(:user).permit(:user_name, :account_name, :website, :introduction, :image, :phone_number, :sex)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
