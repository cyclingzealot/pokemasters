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

ActiveRecord::Schema.define(version: 20180402172906) do

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
