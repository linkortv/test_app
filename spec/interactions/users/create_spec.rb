# spec/interactions/users/create_spec.rb
require 'rails_helper'

RSpec.describe Users::Create do
  describe '#execute' do
    let(:valid_params) do
      {
        name: 'Alex',
        surname: 'Smith',
        email: 'test@mail.ru',
        nationality: 'rus',
        country: 'rus',
        gender: 'male',
        age: 25
      }
    end

    context 'Когда все аттрибуты валидны' do
      it 'Создание нового user-a' do
        expect {
          described_class.run(params: valid_params)
        }.to change(User, :count).by(1)

        user = User.last
        expect(user.name).to eq('Alex')
        expect(user.surname).to eq('Smith')
        expect(user.email).to eq('test@mail.ru')
      end
    end

    context 'Когда email не уникальный' do
      before do
        User.create!(valid_params.merge(full_name: 'Genry Ford'))
      end

      it 'Когда пытаются создать user-а с уже занятым email' do
        result = described_class.run(params: valid_params)

        expect(result).to be_invalid
        expect(result.errors[:email]).to include('Уже используется другим пользователем.')
        expect(User.count).to eq(1)
      end
    end

    context 'Когда возраст не попадает в валидный промежуток' do
      it 'Когда возраст равен 0' do
        params = valid_params.merge(age: 0)
        result = described_class.run(params: params)

        expect(result).to be_invalid
        expect(result.errors[:age]).to include('Должен быть больше 0 и меньше или равен 90.')
      end

      it 'Когда возраст больше 91' do
        params = valid_params.merge(age: 91)
        result = described_class.run(params: params)

        expect(result).to be_invalid
        expect(result.errors[:age]).to include('Должен быть больше 0 и меньше или равен 90.')
      end
    end

    context 'Когда gender не валидный' do
      it 'Если gender отличен от male или female' do
        params = valid_params.merge(gender: 'unknown')
        result = described_class.run(params: params)

        expect(result).to be_invalid
        expect(result.errors[:gender]).to include('Должен быть male или female.')
      end
    end

    context 'Коргда не хватает параметров.' do
      it 'Когда передается пустой параметр.' do
        params = valid_params
        params[:name] = ''
        result = described_class.run(params: params)

        expect(result).to be_invalid
        expect(result.errors[:params]).to include('Заполните все поля')
      end

      it 'Когда параметр не передан.' do
        params = valid_params.except(:name)
        result = described_class.run(params: params)

        expect(result).to be_invalid
        expect(result.errors['params.name']).to include('is required')
        expect(result.errors['params.patronymic']).not_to include('is required')
      end
    end
  end
end
