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

ActiveRecord::Schema.define(version: 2021_01_01_234415) do

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
    t.bigint "vegetable_variet_id", null: false
    t.integer "estimated_turnover"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["bed_id"], name: "index_crop_plan_lines_on_bed_id"
    t.index ["product_id"], name: "index_crop_plan_lines_on_product_id"
    t.index ["vegetable_variet_id"], name: "index_crop_plan_lines_on_vegetable_variet_id"
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

  create_table "gardens", force: :cascade do |t|
    t.string "name"
    t.bigint "farm_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["farm_id"], name: "index_gardens_on_farm_id"
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
    t.integer "yearly_bed_count"
    t.integer "yield_per_sqm"
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
    t.index ["farm_id"], name: "index_products_on_farm_id"
    t.index ["product_group_id"], name: "index_products_on_product_group_id"
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["farm_id"], name: "index_users_on_farm_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
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
  add_foreign_key "crop_plan_lines", "beds"
  add_foreign_key "crop_plan_lines", "products"
  add_foreign_key "crop_plan_lines", "vegetable_variets"
  add_foreign_key "gardens", "farms"
  add_foreign_key "products", "farms"
  add_foreign_key "products", "product_groups"
  add_foreign_key "users", "farms"
  add_foreign_key "vegetable_variets", "products"
end
