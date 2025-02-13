class Users::Create < ActiveInteraction::Base
  # params = { params: { name: 'Alex', surname: 'qwe', email: 'test@mail.ru', nationality: 'rus', country: 'rus', gender: 'boy', age: 12, kad: "dasd" } }
  hash :params do
    string :name
    string :surname
    string :patronymic, default: nil
    string :nationality
    string :country
    string :gender
    string :email
    integer :age
    string :interests, default: nil
    string :skills, default: nil
  end

  validate :email_uniq
  validate :age_in_valid_range
  validate :gender
  validate :missing_params

  def execute
    user_full_name = "#{params[:surname]} #{params[:name]} #{params[:patronymic]}"
    user_params = params.except(:interests, :skills).merge(full_name: user_full_name)
    @user = User.new(user_params)

    append_skills(params['skills']) if params['skills'].present?
    append_interests(params['interests']) if params['interests'].present?

    @user.save
  end

  private

  def missing_params
    errors.add(:params, 'Заполните все поля') if %w[name surname email age nationality country gender].any? { |key| params[key].blank? }
  end

  def age_in_valid_range
    errors.add(:age, 'Должен быть больше 0 и меньше или равен 90.') if params[:age] <= 0 || params[:age] > 90
  end

  def email_uniq
    errors.add(:email, 'Уже используется другим пользователем.') if User.find_by(email: params[:email]).present?
  end

  def gender
    errors.add(:gender, 'Должен быть male или female.') unless ['male','female'].include? params[:gender]
  end

  def append_skills(skills)
    skills.split(',').each do |name|
      skill = Skill.find_or_create_by(name: name)
      @user.skills << skill unless @user.skills.include?(skill)
    end
  end

  def append_interests(interests)
    interests.split(',').each do |name|
      interest = Interest.find_or_create_by(name: name)
      @user.interests << interest unless @user.interests.include?(interest)
    end
  end
end