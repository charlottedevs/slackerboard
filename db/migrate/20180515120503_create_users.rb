class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :slack_identifier
      t.string :slack_handle
      t.string :real_name
      t.string :profile_image

      t.timestamps
    end
  end
end
