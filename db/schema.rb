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

ActiveRecord::Schema.define(version: 2020_10_22_143111) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.integer "minimum", null: false
    t.integer "maximum", null: false
    t.text "description"
    t.string "teacher_name"
    t.boolean "mandatory", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "poll_id"
    t.index ["poll_id"], name: "index_courses_on_poll_id"
  end

  create_table "educational_programs", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_educational_programs_on_name", unique: true
  end

  create_table "grades", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "educational_program_id"
    t.index ["educational_program_id"], name: "index_grades_on_educational_program_id"
    t.index ["name"], name: "index_grades_on_name", unique: true
  end

  create_table "polls", force: :cascade do |t|
    t.string "title", null: false
    t.date "valid_from", null: false
    t.date "valid_until", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "educational_program_id"
    t.index ["educational_program_id"], name: "index_polls_on_educational_program_id"
  end

  create_table "selections", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "poll_id", null: false
    t.bigint "course_id", null: false
    t.integer "priority", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_selections_on_course_id"
    t.index ["poll_id"], name: "index_selections_on_poll_id"
    t.index ["student_id", "poll_id", "priority"], name: "index_selections_on_student_id_and_poll_id_and_priority", unique: true
    t.index ["student_id"], name: "index_selections_on_student_id"
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
    t.index ["email"], name: "index_students_on_email", unique: true
    t.index ["grade_id"], name: "index_students_on_grade_id"
    t.index ["reset_password_token"], name: "index_students_on_reset_password_token", unique: true
  end

  add_foreign_key "courses", "polls"
  add_foreign_key "grades", "educational_programs"
  add_foreign_key "polls", "educational_programs"
  add_foreign_key "selections", "courses"
  add_foreign_key "selections", "polls"
  add_foreign_key "selections", "students"
  add_foreign_key "students", "grades"
end
