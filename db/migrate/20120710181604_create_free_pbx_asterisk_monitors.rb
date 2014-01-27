class CreateFreePbxAsteriskMonitors < ActiveRecord::Migration
  def change
    create_table :free_pbx_asterisk_monitors do |t|
      t.string :uniqueid
      t.string :path

      t.timestamps
    end
  end
end
