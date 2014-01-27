class CreateFreePbxUser < ActiveRecord::Migration
  def change
    create_table :free_pbx_users do |t|
      t.references :dry_auth_user
      t.boolean :email_report
 
      t.timestamps
    end
  end
end
