class CreateCalendarEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :calendar_events do |t|
      t.references :user, null: false, foreign_key: true
      t.string :event_id
      t.string :calendar_id
      t.string :summary
      t.string :hangout_link
      t.text :description
      t.datetime :start
      t.datetime :end

      t.timestamps
    end
  end
end
