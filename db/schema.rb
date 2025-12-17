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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20230510143954) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "categories", force: :cascade do |t|
    t.integer  "position"
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customizations", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "choices"
    t.float    "cost",        default: 0.0
    t.integer  "position"
    t.integer  "product_id"
    t.boolean  "active",      default: true
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "formulas", force: :cascade do |t|
    t.string   "title"
    t.integer  "position"
    t.integer  "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "materials", force: :cascade do |t|
    t.string   "generic"
    t.string   "specific"
    t.float    "cost"
    t.float    "makes"
    t.integer  "position"
    t.integer  "formula_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pages", force: :cascade do |t|
    t.string "code"
    t.text   "post"
  end

  create_table "products", force: :cascade do |t|
    t.string  "title"
    t.text    "description"
    t.integer "price"
    t.integer "minimum"
    t.string  "image_url",   default: ""
    t.integer "maximum",     default: 0
    t.integer "group_size",  default: 1
    t.string  "tags"
    t.integer "category_id"
    t.boolean "active",      default: false
  end

  add_index "products", ["category_id"], name: "index_products_on_category_id", using: :btree

  create_table "sales", force: :cascade do |t|
    t.string   "email"
    t.string   "guid"
    t.string   "stripe_id"
    t.integer  "amount"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.text     "requests"
    t.string   "phone_number"
    t.integer  "quantity",     default: 0
    t.integer  "product_id"
    t.text     "invoice",      default: "--- []\n"
  end

  add_index "sales", ["product_id"], name: "index_sales_on_product_id", using: :btree

end
