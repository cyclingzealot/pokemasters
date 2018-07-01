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

ActiveRecord::Schema.define(version: 20180701220145) do

  create_table "assignments", force: :cascade do |t|
    t.integer "volunteer_id", null: false
    t.integer "meeting_id", null: false
    t.integer "role_id", null: false
    t.boolean "mia"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meeting_id"], name: "index_assignments_on_meeting_id"
    t.index ["role_id"], name: "index_assignments_on_role_id"
    t.index ["volunteer_id"], name: "index_assignments_on_volunteer_id"
  end

  create_table "dummies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "meetings", force: :cascade do |t|
    t.text "location"
    t.text "agenda_uuid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date", null: false
    t.time "time", null: false
    t.index ["agenda_uuid"], name: "index_meetings_on_agenda_uuid", unique: true
  end

  create_table "mentoring_cycles", force: :cascade do |t|
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mentorings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "mentoring_cycle_id", null: false
    t.integer "mentee_id", null: false
    t.integer "mentor_id", null: false
    t.index ["mentee_id"], name: "index_mentorings_on_mentee_id"
    t.index ["mentor_id"], name: "index_mentorings_on_mentor_id"
    t.index ["mentoring_cycle_id"], name: "index_mentorings_on_mentoring_cycle_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.text "name", null: false
    t.text "email"
    t.text "web"
    t.boolean "enabled", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.text "short_name", null: false
    t.text "human_name", null: false
    t.boolean "is_critical", default: false, null: false
    t.text "description_blurb"
    t.text "instructions_blurb"
    t.text "better_role_blurb"
    t.text "equipement_blurb"
    t.integer "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["human_name"], name: "index_roles_on_human_name", unique: true
    t.index ["short_name"], name: "index_roles_on_short_name", unique: true
  end

  create_table "volunteer_taggings", force: :cascade do |t|
    t.integer "volunteer_id"
    t.integer "volunteer_tag_id"
    t.integer "organization_id", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_volunteer_taggings_on_organization_id"
    t.index ["volunteer_id", "volunteer_tag_id", "organization_id"], name: "unique_combo", unique: true
    t.index ["volunteer_id"], name: "index_volunteer_taggings_on_volunteer_id"
    t.index ["volunteer_tag_id"], name: "index_volunteer_taggings_on_volunteer_tag_id"
  end

  create_table "volunteer_tags", force: :cascade do |t|
    t.text "short_name"
    t.string "name_english"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "volunteers", force: :cascade do |t|
    t.text "name", null: false
    t.text "email", null: false
    t.text "cell"
    t.text "tie_breaker_uuid", null: false
    t.datetime "last_synched", null: false
    t.date "dont_bug_unitl"
    t.boolean "dont_bug_ever"
    t.text "dont_bug_ever_because"
    t.boolean "is_member", default: false, null: false
    t.text "external_org_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cell"], name: "index_volunteers_on_cell", unique: true
    t.index ["external_org_id"], name: "index_volunteers_on_external_org_id", unique: true
    t.index ["tie_breaker_uuid"], name: "index_volunteers_on_tie_breaker_uuid", unique: true
  end

end
