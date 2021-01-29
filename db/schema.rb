# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_29_214545) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "beds", force: :cascade do |t|
    t.bigint "garden_id", null: false
    t.string "name"
    t.boolean "greenhouse"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["garden_id"], name: "index_beds_on_garden_id"
  end

  create_table "crop_plan_line_events", force: :cascade do |t|
    t.bigint "crop_plan_line_id", null: false
    t.boolean "different_from_original"
    t.datetime "date_done"
    t.datetime "date_planned"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "comment"
    t.integer "order"
    t.index ["crop_plan_line_id"], name: "index_crop_plan_line_events_on_crop_plan_line_id"
  end

  create_table "crop_plan_line_user_events", force: :cascade do |t|
    t.bigint "crop_plan_line_event_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["crop_plan_line_event_id"], name: "index_crop_plan_line_user_events_on_crop_plan_line_event_id"
    t.index ["user_id"], name: "index_crop_plan_line_user_events_on_user_id"
  end

  create_table "crop_plan_lines", force: :cascade do |t|
    t.date "planting_date"
    t.date "harvest_start_date"
    t.date "harvest_end_date"
    t.bigint "bed_id", null: false
    t.bigint "product_id", null: false
    t.integer "meter_count"
    t.string "seedling_type"
    t.string "comment"
    t.boolean "different_from_original"
    t.bigint "vegetable_variet_id"
    t.integer "estimated_turnover"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["bed_id"], name: "index_crop_plan_lines_on_bed_id"
    t.index ["product_id"], name: "index_crop_plan_lines_on_product_id"
    t.index ["vegetable_variet_id"], name: "index_crop_plan_lines_on_vegetable_variet_id"
  end

  create_table "events", force: :cascade do |t|
    t.datetime "date"
    t.string "description"
    t.string "details"
    t.string "comment"
    t.string "event_category"
    t.string "event_subcategory"
    t.datetime "date_done"
    t.bigint "farm_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.index ["farm_id"], name: "index_events_on_farm_id"
  end

  create_table "farms", force: :cascade do |t|
    t.string "full_name"
    t.string "shortened_name"
    t.string "logo"
    t.string "address"
    t.string "zip_code"
    t.string "city"
    t.string "siret"
    t.integer "ttc_turnover", default: 0
    t.integer "ht_turnover", default: 0
    t.integer "estimated_ttc_turnover", default: 0
    t.integer "estimated_ht_turnover", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "gardens", force: :cascade do |t|
    t.string "name"
    t.bigint "farm_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["farm_id"], name: "index_gardens_on_farm_id"
  end

  create_table "outlet_groups", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.integer "ht_turnover"
    t.integer "ttc_turnover"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "outlets", force: :cascade do |t|
    t.string "full_name"
    t.string "shortened_name"
    t.string "logo"
    t.string "address"
    t.string "zip_code"
    t.string "city"
    t.string "email"
    t.string "phone_number"
    t.integer "ht_turnover"
    t.integer "ttc_turnover"
    t.string "total_paid_amount"
    t.boolean "has_customers"
    t.bigint "outlet_group_id", null: false
    t.bigint "farm_id", null: false
    t.string "color"
    t.string "preferred_payment_method"
    t.string "comment"
    t.string "invoicing"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "phone_number_owner"
    t.index ["farm_id"], name: "index_outlets_on_farm_id"
    t.index ["outlet_group_id"], name: "index_outlets_on_outlet_group_id"
  end

  create_table "presence_periods", force: :cascade do |t|
    t.datetime "date"
    t.boolean "on_call_period"
    t.string "comment"
    t.string "moment_in_day"
    t.boolean "specific_moment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "start_time"
    t.datetime "end_time"
  end

  create_table "product_groups", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "simplified_name"
    t.string "product_type"
    t.string "general_unit"
    t.integer "general_price_final_client"
    t.integer "general_price_intermediary"
    t.decimal "yearly_bed_count"
    t.decimal "yield_per_sqm"
    t.integer "estimated_turnover"
    t.bigint "farm_id", null: false
    t.bigint "product_group_id", null: false
    t.string "color"
    t.integer "spacing"
    t.integer "row_count"
    t.integer "loss_percentage"
    t.integer "growth_duration_in_weeks"
    t.integer "harvest_duration_in_weeks"
    t.integer "ht_turnover"
    t.integer "ttc_turnover"
    t.string "picture"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.index ["farm_id"], name: "index_products_on_farm_id"
    t.index ["product_group_id"], name: "index_products_on_product_group_id"
    t.index ["slug"], name: "index_products_on_slug", unique: true
  end

  create_table "sales", force: :cascade do |t|
    t.datetime "date"
    t.bigint "outlet_id", null: false
    t.integer "ht_total"
    t.integer "ttc_total"
    t.integer "rounded_ht_total"
    t.integer "rounded_ttc_total"
    t.boolean "recurrent"
    t.string "frequency"
    t.string "comment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["outlet_id"], name: "index_sales_on_outlet_id"
  end

  create_table "user_events", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id"], name: "index_user_events_on_event_id"
    t.index ["user_id"], name: "index_user_events_on_user_id"
  end

  create_table "user_presence_periods", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "presence_period_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["presence_period_id"], name: "index_user_presence_periods_on_presence_period_id"
    t.index ["user_id"], name: "index_user_presence_periods_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "last_name"
    t.string "gender", default: "F"
    t.boolean "manager", default: false
    t.boolean "worker", default: false
    t.boolean "admin", default: false
    t.string "picture"
    t.string "color"
    t.bigint "farm_id", null: false
    t.string "phone_number"
    t.string "slug"
    t.string "nickname"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["farm_id"], name: "index_users_on_farm_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

  create_table "vegetable_variets", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "name"
    t.string "details"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_vegetable_variets_on_product_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "beds", "gardens"
  add_foreign_key "crop_plan_line_events", "crop_plan_lines"
  add_foreign_key "crop_plan_line_user_events", "crop_plan_line_events"
  add_foreign_key "crop_plan_line_user_events", "users"
  add_foreign_key "crop_plan_lines", "beds"
  add_foreign_key "crop_plan_lines", "products"
  add_foreign_key "crop_plan_lines", "vegetable_variets"
  add_foreign_key "events", "farms"
  add_foreign_key "gardens", "farms"
  add_foreign_key "outlets", "farms"
  add_foreign_key "outlets", "outlet_groups"
  add_foreign_key "products", "farms"
  add_foreign_key "products", "product_groups"
  add_foreign_key "sales", "outlets"
  add_foreign_key "user_events", "events"
  add_foreign_key "user_events", "users"
  add_foreign_key "user_presence_periods", "presence_periods"
  add_foreign_key "user_presence_periods", "users"
  add_foreign_key "users", "farms"
  add_foreign_key "vegetable_variets", "products"
end
