# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130605144503) do

  create_table "activities", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "location"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer  "event_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "activityposts", :force => true do |t|
    t.integer  "post_id"
    t.integer  "activity_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "activityposts", ["activity_id"], :name => "index_activityposts_on_activity_id"
  add_index "activityposts", ["post_id", "activity_id"], :name => "index_activityposts_on_post_id_and_activity_id", :unique => true
  add_index "activityposts", ["post_id"], :name => "index_activityposts_on_post_id"

  create_table "albumactivities", :force => true do |t|
    t.integer  "activity_id"
    t.integer  "album_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "albums", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "privacy"
    t.integer  "user_id"
    t.integer  "cover_photo_id"
    t.string   "type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "albumable_id"
    t.string   "albumable_type"
  end

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "username"
  end

  create_table "comments", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "photo_id"
  end

  add_index "comments", ["user_id", "created_at", "post_id"], :name => "index_comments_on_user_id_and_created_at_and_post_id"

  create_table "communities", :force => true do |t|
    t.integer  "community_id"
    t.integer  "user_id"
    t.integer  "photo_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "name"
    t.text     "description"
  end

  create_table "event_editor_groups", :force => true do |t|
    t.integer  "event_id"
    t.integer  "group_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "event_editor_groups", ["event_id", "group_id"], :name => "index_event_editor_groups_on_event_id_and_group_id", :unique => true
  add_index "event_editor_groups", ["event_id"], :name => "index_event_editor_groups_on_event_id"
  add_index "event_editor_groups", ["group_id"], :name => "index_event_editor_groups_on_group_id"

  create_table "event_editor_users", :force => true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "event_editor_users", ["event_id", "user_id"], :name => "index_event_editor_users_on_event_id_and_user_id", :unique => true
  add_index "event_editor_users", ["event_id"], :name => "index_event_editor_users_on_event_id"
  add_index "event_editor_users", ["user_id"], :name => "index_event_editor_users_on_user_id"

  create_table "event_editors", :force => true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "event_editors", ["event_id", "user_id"], :name => "index_event_editors_on_event_id_and_user_id", :unique => true
  add_index "event_editors", ["event_id"], :name => "index_event_editors_on_event_id"
  add_index "event_editors", ["user_id"], :name => "index_event_editors_on_user_id"

  create_table "event_invited_groups", :force => true do |t|
    t.integer  "event_id"
    t.integer  "group_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "event_invited_groups", ["event_id", "group_id"], :name => "index_event_invited_groups_on_event_id_and_group_id", :unique => true
  add_index "event_invited_groups", ["event_id"], :name => "index_event_invited_groups_on_event_id"
  add_index "event_invited_groups", ["group_id"], :name => "index_event_invited_groups_on_group_id"

  create_table "event_invited_users", :force => true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "event_invited_users", ["event_id", "user_id"], :name => "index_event_invited_users_on_event_id_and_user_id", :unique => true
  add_index "event_invited_users", ["event_id"], :name => "index_event_invited_users_on_event_id"
  add_index "event_invited_users", ["user_id"], :name => "index_event_invited_users_on_user_id"

  create_table "events", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "location"
    t.boolean  "privacy"
    t.integer  "creator"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.boolean  "all_day"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "events", ["creator", "created_at", "starts_at", "ends_at"], :name => "index_events_on_creator_and_created_at_and_starts_at_and_ends_at"

  create_table "groupposts", :force => true do |t|
    t.integer  "post_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "group_id"
  end

  add_index "groupposts", ["group_id"], :name => "index_groupposts_on_group_id"
  add_index "groupposts", ["post_id", "group_id"], :name => "index_groupposts_on_post_id_and_group_id", :unique => true
  add_index "groupposts", ["post_id"], :name => "index_groupposts_on_post_id"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "privacy"
    t.integer  "User_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "photo_id"
  end

  add_index "groups", ["User_id"], :name => "index_groups_on_User_id"

  create_table "identities", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "microposts", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "microposts", ["user_id", "created_at"], :name => "index_microposts_on_user_id_and_created_at"

  create_table "photoalbums", :force => true do |t|
    t.integer  "photo_id"
    t.integer  "album_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "photos", :force => true do |t|
    t.integer  "post_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "pic_file_name"
    t.string   "pic_content_type"
    t.integer  "pic_file_size"
    t.datetime "pic_updated_at"
    t.string   "pic"
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
  end

  create_table "posts", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "posts", ["user_id", "created_at"], :name => "index_posts_on_user_id_and_created_at"

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], :name => "index_relationships_on_follower_id_and_followed_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "shares", :force => true do |t|
    t.integer  "share_id"
    t.integer  "album_id"
    t.string   "type"
    t.datetime "creation_date"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "user_groups", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "community_id"
  end

  add_index "user_groups", ["group_id"], :name => "index_user_groups_on_group_id"
  add_index "user_groups", ["user_id", "group_id"], :name => "index_user_groups_on_user_id_and_group_id", :unique => true
  add_index "user_groups", ["user_id"], :name => "index_user_groups_on_user_id"

  create_table "usercommunities", :force => true do |t|
    t.integer  "community_id"
    t.integer  "user_id"
    t.string   "status"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.boolean  "admin"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
