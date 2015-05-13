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

ActiveRecord::Schema.define(version: 20150513140511) do

  create_table "altas_bajas_horas", force: true do |t|
    t.integer  "establecimiento_id"
    t.integer  "mes_periodo"
    t.integer  "anio_periodo"
    t.integer  "persona_id"
    t.integer  "secuencia"
    t.date     "fecha_alta"
    t.date     "fecha_baja"
    t.string   "situacion_revista"
    t.integer  "horas"
    t.integer  "ciclo_carrera"
    t.integer  "anio"
    t.integer  "division"
    t.string   "turno"
    t.integer  "codificacion"
    t.string   "oblig"
    t.string   "observaciones"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "altas_bajas_horas", ["establecimiento_id"], name: "index_altas_bajas_horas_on_establecimiento_id", using: :btree
  add_index "altas_bajas_horas", ["persona_id"], name: "index_altas_bajas_horas_on_persona_id", using: :btree

  create_table "articulos", force: true do |t|
    t.string   "codigo"
    t.string   "descripcion"
    t.integer  "cantidad_maxima_dias"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "establecimientos", force: true do |t|
    t.string   "codigo_jurisdiccional"
    t.integer  "cue"
    t.integer  "anexo"
    t.integer  "cue_anexo"
    t.string   "sector"
    t.string   "ambito"
    t.string   "nombre"
    t.integer  "localidad_id"
    t.string   "domicilio"
    t.string   "responsable"
    t.string   "tipo"
    t.string   "zona"
    t.integer  "cuise"
    t.date     "alta"
    t.date     "baja"
    t.string   "dependencia"
    t.string   "email"
    t.string   "isotipo"
    t.string   "nivel_id"
    t.string   "ift"
    t.integer  "numero"
    t.boolean  "privada"
    t.string   "rght"
    t.string   "sistema"
    t.integer  "organizacion_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "establecimientos_users", force: true do |t|
    t.integer  "establecimiento_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "estado_civils", force: true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "localidads", force: true do |t|
    t.string   "nombre"
    t.integer  "region_id"
    t.integer  "cp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nivels", force: true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "oficinas", force: true do |t|
    t.integer  "nombre"
    t.integer  "tipo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "periodo_liq_horas", force: true do |t|
    t.integer  "mes"
    t.integer  "anio"
    t.integer  "altas_bajas_hora_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "periodo_liq_horas", ["altas_bajas_hora_id"], name: "index_periodo_liq_horas_on_altas_bajas_hora_id", using: :btree

  create_table "permissions", force: true do |t|
    t.integer  "user_id"
    t.string   "nombre"
    t.string   "subject_class"
    t.integer  "subject_id"
    t.string   "action"
    t.text     "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personas", force: true do |t|
    t.string   "nombres"
    t.string   "apellidos"
    t.integer  "tipo_documento_id"
    t.integer  "nro_documento"
    t.string   "calle"
    t.integer  "nro_calle"
    t.string   "piso"
    t.string   "depto"
    t.integer  "estado_civil_id"
    t.integer  "sexo_id"
    t.date     "fecha_nacimiento"
    t.integer  "localidad_id"
    t.string   "telefono_contacto"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cuil"
  end

  create_table "rails_admin_histories", force: true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      limit: 2
    t.integer  "year",       limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], name: "index_rails_admin_histories", using: :btree

  create_table "regions", force: true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "role_permissions", force: true do |t|
    t.integer  "role_id"
    t.string   "regulator"
    t.string   "conduct"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "role_roles", force: true do |t|
    t.integer  "role_id"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sexos", force: true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "situacion_revista", force: true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tipo_documentos", force: true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_roles", force: true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "apellidos"
    t.string   "nombres"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "utils", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
