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

ActiveRecord::Schema.define(version: 2021_05_18_194201) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

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
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "courses", force: :cascade do |t|
    t.string "title", null: false
    t.integer "minimum"
    t.integer "maximum"
    t.string "teacher_name"
    t.boolean "guaranteed", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "poll_id"
    t.string "focus_areas"
    t.string "variants"
    t.bigint "parent_course_id"
    t.string "number"
    t.index ["parent_course_id"], name: "index_courses_on_parent_course_id"
    t.index ["poll_id"], name: "index_courses_on_poll_id"
  end

  create_table "courses_students", id: false, force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "student_id", null: false
    t.index ["course_id", "student_id"], name: "index_courses_students_on_course_id_and_student_id", unique: true
  end

  create_table "grades", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "valid_until"
    t.index ["name"], name: "index_grades_on_name", unique: true
  end

  create_table "grades_polls", id: false, force: :cascade do |t|
    t.bigint "grade_id", null: false
    t.bigint "poll_id", null: false
    t.index ["grade_id", "poll_id"], name: "index_grades_polls_on_grade_id_and_poll_id", unique: true
  end

  create_table "polls", force: :cascade do |t|
    t.string "title", null: false
    t.date "valid_from", null: false
    t.date "valid_until", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "completed", precision: 6
  end

  create_table "selections", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "top_course_id"
    t.bigint "mid_course_id"
    t.bigint "low_course_id"
    t.bigint "poll_id"
    t.index ["low_course_id"], name: "index_selections_on_low_course_id"
    t.index ["mid_course_id"], name: "index_selections_on_mid_course_id"
    t.index ["poll_id", "student_id"], name: "index_selections_on_poll_id_and_student_id", unique: true
    t.index ["poll_id"], name: "index_selections_on_poll_id"
    t.index ["student_id"], name: "index_selections_on_student_id"
    t.index ["top_course_id"], name: "index_selections_on_top_course_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.bigint "grade_id"
    t.datetime "paused_at", precision: 6
    t.index ["email"], name: "index_students_on_email", unique: true
    t.index ["grade_id"], name: "index_students_on_grade_id"
    t.index ["reset_password_token"], name: "index_students_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "courses", "courses", column: "parent_course_id"
  add_foreign_key "courses", "polls"
  add_foreign_key "selections", "courses", column: "low_course_id"
  add_foreign_key "selections", "courses", column: "mid_course_id"
  add_foreign_key "selections", "courses", column: "top_course_id"
  add_foreign_key "selections", "polls"
  add_foreign_key "selections", "students"
  add_foreign_key "students", "grades"
end
