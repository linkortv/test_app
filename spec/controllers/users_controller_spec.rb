# spec/controllers/users_controller_spec.rb
require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST #create' do
    let(:valid_params) do
      {
        name: 'Alex',
        surname: 'Smith',
        email: 'test@mail.ru',
        nationality: 'rus',
        country: 'rus',
        gender: 'male',
        age: '25'
      }
    end

    let(:invalid_params) do
      {
        name: '',
        surname: 'Smith',
        email: 'test@mail.ru',
        nationality: 'rus',
        country: 'rus',
        gender: 'male',
        age: 'invalid_age'
      }
    end

    context 'Когда параметры валидные' do
      it 'Перенаправляет на главную страницу' do
        post :create, params: valid_params

        expect(response).to redirect_to(root_path)
      end
    end

    context 'Когда параметры не валидные' do
      it 'Должен остаться на странице создания пользователя' do
        post :create, params: invalid_params

        expected_uri = URI.parse(new_user_path(locals: 'error_message')).path
        actual_uri = URI.parse(response.headers['Location']).path

        expect(actual_uri).to eq(expected_uri)
      end
    end
  end
end
