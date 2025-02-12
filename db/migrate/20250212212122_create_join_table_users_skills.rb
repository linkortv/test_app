class CreateJoinTableUsersSkills < ActiveRecord::Migration[8.0]
  def change
    create_join_table :users, :skills do |t|
      t.index :user_id
      t.index :skill_id
    end
  end
end
