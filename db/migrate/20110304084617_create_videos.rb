class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.string    :name
      t.string    :asset_file_name
      t.string    :asset_content_type
      t.integer   :asset_file_size
      t.datetime  :asset_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :videos
  end
end
