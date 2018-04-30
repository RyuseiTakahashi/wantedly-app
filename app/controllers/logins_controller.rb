class LoginsController < ApplicationController
    def show
        render "new"
    end
  
    def create
      user = User.find_by_name params[:name]
      if user.password_digest == params[:pass]
        # セッションのキー:user_idへユーザーのIDを登録
        session[:user_id] = user.id
        redirect_to controller: 'skills', action: 'show', id: user.id
      else
        # flash変数にメッセージをセット
        flash.now.alert = "もう一度入力してください。"
        render "new"
      end
    end
  
    def destroy
      session[:user_id] = nil
      @current_user = nil
      redirect_to logins_path
    end
end
