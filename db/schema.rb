# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_03_19_000001) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admins", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at", precision: nil
    t.datetime "reset_password_sent_at", precision: nil
    t.string "reset_password_token"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "cart_inquiries", force: :cascade do |t|
    t.jsonb "cart", default: [], null: false
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.text "message"
    t.string "phone", default: "", null: false
    t.string "status", default: "new", null: false
    t.decimal "total", precision: 12, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_cart_inquiries_on_created_at"
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "position"
    t.string "title"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "customizations", id: :serial, force: :cascade do |t|
    t.boolean "active", default: true
    t.string "choices"
    t.float "cost", default: 0.0
    t.datetime "created_at", precision: nil, null: false
    t.text "description"
    t.integer "position"
    t.integer "product_id"
    t.string "title"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "formulas", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "position"
    t.integer "product_id"
    t.string "title"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "greeting_cards", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.float "fold_ratio_front"
    t.float "fold_ratio_inside"
    t.jsonb "front_layers", default: [], null: false
    t.float "front_offset_x"
    t.float "front_offset_y"
    t.float "front_scale"
    t.jsonb "inside_layers", default: [], null: false
    t.float "inside_offset_x"
    t.float "inside_offset_y"
    t.float "inside_scale"
    t.bigint "product_id", null: false
    t.string "sheet_format", default: "letter", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_greeting_cards_on_product_id"
  end

  create_table "materials", id: :serial, force: :cascade do |t|
    t.float "cost"
    t.datetime "created_at", precision: nil, null: false
    t.integer "formula_id"
    t.string "generic"
    t.float "makes"
    t.integer "position"
    t.string "specific"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "pages", id: :serial, force: :cascade do |t|
    t.string "code"
    t.text "post"
  end

  create_table "products", id: :serial, force: :cascade do |t|
    t.boolean "active", default: false
    t.integer "category_id"
    t.text "description"
    t.integer "group_size", default: 1
    t.string "image_url", default: ""
    t.integer "maximum", default: 0
    t.integer "minimum"
    t.integer "price"
    t.string "tags"
    t.string "title"
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  create_table "sales", id: :serial, force: :cascade do |t|
    t.integer "amount"
    t.datetime "created_at", precision: nil, null: false
    t.string "email"
    t.string "guid"
    t.text "invoice", default: "--- []\n"
    t.string "phone_number"
    t.integer "product_id"
    t.integer "quantity", default: 0
    t.text "requests"
    t.string "stripe_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["product_id"], name: "index_sales_on_product_id"
  end
end
