class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def create
    params[:age] = params[:age].to_i # Костыль, но рабочий костыль
    user = Users::Create.run(params: permitted_params)

    redirect_to user.valid? ? root_path : new_user_path(locals: "#{user.errors.first.attribute} #{user.errors.first.type}")
  end

  def new; end

  private

  def permitted_params
    params.permit(:name, :surname, :patronymic, :full_name, :email, :age, :nationality, :country, :gender, :skills, :interests)
  end
end
