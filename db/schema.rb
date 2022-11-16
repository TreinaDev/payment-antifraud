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

ActiveRecord::Schema[7.0].define(version: 2022_11_13_214754) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "company_payment_options", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "insurance_company_id", null: false
    t.integer "payment_method_id", null: false
    t.integer "max_parcels"
    t.integer "single_parcel_discount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["insurance_company_id"], name: "index_company_payment_options_on_insurance_company_id"
    t.index ["payment_method_id"], name: "index_company_payment_options_on_payment_method_id"
    t.index ["user_id"], name: "index_company_payment_options_on_user_id"
  end

  create_table "fraud_reports", force: :cascade do |t|
    t.string "registration_number"
    t.string "description"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "insurance_companies", force: :cascade do |t|
    t.integer "external_insurance_company"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "name"
    t.integer "tax_percentage"
    t.integer "tax_maximum"
    t.string "payment_type"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "promo_products", force: :cascade do |t|
    t.integer "product_id"
    t.integer "promo_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["promo_id", "product_id"], name: "index_promo_products_on_promo_id_and_product_id", unique: true
    t.index ["promo_id"], name: "index_promo_products_on_promo_id"
  end

  create_table "promos", force: :cascade do |t|
    t.date "starting_date"
    t.date "ending_date"
    t.string "name"
    t.integer "discount_percentage"
    t.integer "discount_max", null: false
    t.integer "usages_max"
    t.string "voucher"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "insurance_company_id", null: false
    t.index ["insurance_company_id"], name: "index_promos_on_insurance_company_id"
  end

  create_table "user_reviews", force: :cascade do |t|
    t.string "refusal"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.index ["user_id"], name: "index_user_reviews_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.string "registration_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.integer "insurance_company_id", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["insurance_company_id"], name: "index_users_on_insurance_company_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "company_payment_options", "insurance_companies"
  add_foreign_key "company_payment_options", "payment_methods"
  add_foreign_key "company_payment_options", "users"
  add_foreign_key "promo_products", "promos"
  add_foreign_key "promos", "insurance_companies"
  add_foreign_key "user_reviews", "users"
  add_foreign_key "users", "insurance_companies"
end
