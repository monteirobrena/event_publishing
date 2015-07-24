class CreateGroupEvents < ActiveRecord::Migration
  def change
    create_table :group_events do |t|
      t.string    :name
      t.text      :description
      t.string    :location
      t.integer   :duration
      t.boolean   :published, default: false
      t.date      :start_date
      t.date      :end_date
      t.boolean   :archived, default: false

      t.timestamps
    end
  end
end
