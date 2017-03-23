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

ActiveRecord::Schema.define(version: 20170321120051) do

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "altas_bajas_hora_estados", force: true do |t|
    t.integer  "alta_baja_hora_id"
    t.integer  "estado_id"
    t.text     "observaciones"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "altas_bajas_hora_estados", ["alta_baja_hora_id"], name: "index_altas_bajas_hora_estados_on_alta_baja_hora_id", using: :btree
  add_index "altas_bajas_hora_estados", ["estado_id"], name: "index_altas_bajas_hora_estados_on_estado_id", using: :btree

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
    t.string   "codificacion"
    t.string   "oblig"
    t.string   "observaciones"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lote_impresion_id"
    t.integer  "baja_lote_impresion_id"
    t.integer  "empresa_id"
    t.integer  "lugar_pago_id"
    t.string   "estado"
    t.boolean  "con_movilidad"
    t.integer  "materium_id"
    t.integer  "grupo_id"
    t.string   "motivo_baja"
    t.integer  "plan_id"
    t.integer  "suplente_id"
    t.string   "lic_art"
    t.date     "fecha_alta_licencia"
    t.integer  "categ"
    t.integer  "secuencia_aux"
    t.boolean  "programatica"
  end

  add_index "altas_bajas_horas", ["establecimiento_id"], name: "index_altas_bajas_horas_on_establecimiento_id", using: :btree
  add_index "altas_bajas_horas", ["persona_id"], name: "index_altas_bajas_horas_on_persona_id", using: :btree
  add_index "altas_bajas_horas", ["suplente_id"], name: "index_altas_bajas_horas_on_suplente_id", using: :btree

  create_table "ambitos", force: true do |t|
    t.string   "nombre"
    t.integer  "inscripcion_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ambitos", ["inscripcion_id"], name: "index_ambitos_on_inscripcion_id", using: :btree

  create_table "articulos", force: true do |t|
    t.string   "codigo"
    t.string   "descripcion"
    t.integer  "cantidad_maxima_dias"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "suplencia"
    t.boolean  "con_goce"
    t.integer  "tipo_articulo_id"
  end

  create_table "asistencia", force: true do |t|
    t.integer  "ina_justificada"
    t.integer  "ina_injustificada"
    t.integer  "ina_total"
    t.integer  "lleg_tarde_justificada"
    t.integer  "lleg_tarde_injustificada"
    t.integer  "lleg_tarde_total"
    t.integer  "altas_bajas_hora_id"
    t.integer  "altas_bajas_cargo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "anio_periodo"
    t.integer  "mes_periodo"
  end

  add_index "asistencia", ["altas_bajas_cargo_id"], name: "index_asistencia_on_altas_bajas_cargo_id", using: :btree
  add_index "asistencia", ["altas_bajas_hora_id"], name: "index_asistencia_on_altas_bajas_hora_id", using: :btree

  create_table "asistencia_estados", force: true do |t|
    t.integer  "asistencia_id"
    t.integer  "estado_id"
    t.integer  "user_id"
    t.text     "observaciones"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "asistencia_estados", ["asistencia_id"], name: "index_asistencia_estados_on_asistencia_id", using: :btree
  add_index "asistencia_estados", ["estado_id"], name: "index_asistencia_estados_on_estado_id", using: :btree
  add_index "asistencia_estados", ["user_id"], name: "index_asistencia_estados_on_user_id", using: :btree

  create_table "cargo_estados", force: true do |t|
    t.integer  "cargo_id"
    t.integer  "estado_id"
    t.integer  "user_id"
    t.text     "observaciones"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cargo_estados", ["cargo_id"], name: "index_cargo_estados_on_cargo_id", using: :btree
  add_index "cargo_estados", ["estado_id"], name: "index_cargo_estados_on_estado_id", using: :btree
  add_index "cargo_estados", ["user_id"], name: "index_cargo_estados_on_user_id", using: :btree

  create_table "cargo_inscrip_docs", force: true do |t|
    t.integer  "persona_id"
    t.integer  "cargosnds_id"
    t.integer  "cargo_id"
    t.integer  "nivel_id"
    t.integer  "inscripcion_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cargo_inscrip_docs", ["cargo_id"], name: "index_cargo_inscrip_docs_on_cargo_id", using: :btree
  add_index "cargo_inscrip_docs", ["cargosnds_id"], name: "index_cargo_inscrip_docs_on_cargosnds_id", using: :btree
  add_index "cargo_inscrip_docs", ["inscripcion_id"], name: "index_cargo_inscrip_docs_on_inscripcion_id", using: :btree
  add_index "cargo_inscrip_docs", ["nivel_id"], name: "index_cargo_inscrip_docs_on_nivel_id", using: :btree
  add_index "cargo_inscrip_docs", ["persona_id"], name: "index_cargo_inscrip_docs_on_persona_id", using: :btree

  create_table "cargo_no_docente_estados", force: true do |t|
    t.integer  "cargo_no_docente_id"
    t.integer  "estado_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.text     "observaciones"
  end

  add_index "cargo_no_docente_estados", ["cargo_no_docente_id"], name: "index_cargo_no_docente_estados_on_cargo_no_docente_id", using: :btree
  add_index "cargo_no_docente_estados", ["estado_id"], name: "index_cargo_no_docente_estados_on_estado_id", using: :btree
  add_index "cargo_no_docente_estados", ["user_id"], name: "index_cargo_no_docente_estados_on_user_id", using: :btree

  create_table "cargo_no_docentes", force: true do |t|
    t.integer  "establecimiento_id"
    t.integer  "persona_id"
    t.string   "cargo"
    t.integer  "secuencia"
    t.string   "turno"
    t.date     "fecha_alta"
    t.date     "fecha_baja"
    t.integer  "persona_reemplazada_id"
    t.string   "observaciones"
    t.integer  "alta_lote_impresion_id"
    t.integer  "baja_lote_impresion_id"
    t.integer  "empresa_id"
    t.integer  "lugar_pago_id"
    t.boolean  "con_movilidad"
    t.integer  "ina_injustificadas"
    t.date     "licencia_desde"
    t.date     "licencia_hasta"
    t.integer  "cantidad_dias_licencia"
    t.text     "motivo_baja"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "estado"
    t.string   "situacion_revista"
  end

  add_index "cargo_no_docentes", ["alta_lote_impresion_id"], name: "index_cargo_no_docentes_on_alta_lote_impresion_id", using: :btree
  add_index "cargo_no_docentes", ["baja_lote_impresion_id"], name: "index_cargo_no_docentes_on_baja_lote_impresion_id", using: :btree
  add_index "cargo_no_docentes", ["establecimiento_id"], name: "index_cargo_no_docentes_on_establecimiento_id", using: :btree
  add_index "cargo_no_docentes", ["persona_id"], name: "index_cargo_no_docentes_on_persona_id", using: :btree
  add_index "cargo_no_docentes", ["persona_reemplazada_id"], name: "index_cargo_no_docentes_on_persona_reemplazada_id", using: :btree

  create_table "cargos", force: true do |t|
    t.integer  "establecimiento_id"
    t.integer  "persona_id"
    t.string   "cargo"
    t.integer  "secuencia"
    t.string   "situacion_revista"
    t.string   "turno"
    t.integer  "anio"
    t.integer  "curso"
    t.date     "fecha_alta"
    t.date     "fecha_baja"
    t.integer  "persona_reemplazada_id"
    t.string   "observatorio"
    t.integer  "alta_lote_impresion_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "division"
    t.text     "observaciones"
    t.integer  "baja_lote_impresion_id"
    t.integer  "empresa_id"
    t.integer  "lugar_pago_id"
    t.boolean  "con_movilidad"
    t.integer  "grupo_id"
    t.integer  "ina_injustificadas"
    t.date     "licencia_desde"
    t.date     "licencia_hasta"
    t.integer  "cantidad_dias_licencia"
    t.string   "motivo_baja"
    t.string   "materium_id"
<<<<<<< HEAD
    t.string   "estado",                 limit: 45, null: false
=======
>>>>>>> 6112659225d44e898c662f4b4b7088a5874c10cf
  end

  add_index "cargos", ["establecimiento_id"], name: "index_cargos_on_establecimiento_id", using: :btree
  add_index "cargos", ["persona_id"], name: "index_cargos_on_persona_id", using: :btree
  add_index "cargos", ["persona_reemplazada_id"], name: "index_cargos_on_persona_reemplazada_id", using: :btree

  create_table "cargosnds", force: true do |t|
    t.integer  "cargo_agrup"
    t.integer  "cargo_cod"
    t.integer  "cargo_categ"
    t.integer  "nivel"
    t.string   "cargo_desc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "despliegues", force: true do |t|
    t.integer  "anio"
    t.integer  "plan_id"
    t.integer  "materium_id"
    t.integer  "carga_horaria"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cant_docentes"
    t.string   "observacion"
  end

  add_index "despliegues", ["materium_id"], name: "index_despliegues_on_materium_id", using: :btree
  add_index "despliegues", ["plan_id"], name: "index_despliegues_on_plan_id", using: :btree

  create_table "empresas", force: true do |t|
    t.string   "nombre"
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "establecimiento_plans", force: true do |t|
    t.integer  "establecimiento_id"
    t.integer  "plan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "establecimiento_plans", ["establecimiento_id"], name: "index_establecimiento_plans_on_establecimiento_id", using: :btree
  add_index "establecimiento_plans", ["plan_id"], name: "index_establecimiento_plans_on_plan_id", using: :btree

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

  create_table "estados", force: true do |t|
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "funcions", force: true do |t|
    t.string   "categoria"
    t.string   "tipo_cargo"
    t.string   "descripcion"
    t.integer  "grupo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nivel"
  end

  create_table "grupos", force: true do |t|
    t.string   "nombre"
    t.text     "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inscripcions", force: true do |t|
    t.integer  "establecimiento_id"
    t.integer  "funcion_id"
    t.integer  "nivel_id"
    t.string   "escuela_titular"
    t.string   "serv_activo"
    t.string   "lugar_serv_act"
    t.string   "documentacion"
    t.integer  "rubro_id"
    t.date     "fecha_incripcion"
    t.integer  "persona_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cabecera"
    t.integer  "user_id"
  end

  add_index "inscripcions", ["establecimiento_id"], name: "index_inscripcions_on_establecimiento_id", using: :btree
  add_index "inscripcions", ["funcion_id"], name: "index_inscripcions_on_funcion_id", using: :btree
  add_index "inscripcions", ["nivel_id"], name: "index_inscripcions_on_nivel_id", using: :btree
  add_index "inscripcions", ["persona_id"], name: "index_inscripcions_on_persona_id", using: :btree
  add_index "inscripcions", ["rubro_id"], name: "index_inscripcions_on_rubro_id", using: :btree

  create_table "licencia", force: true do |t|
    t.integer  "altas_bajas_hora_id"
    t.date     "fecha_desde"
    t.date     "fecha_hasta"
    t.integer  "articulo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cargo_id"
    t.integer  "cargo_no_docente_id"
    t.text     "observaciones"
    t.string   "vigente"
  end

  add_index "licencia", ["altas_bajas_hora_id"], name: "index_licencia_on_altas_bajas_hora_id", using: :btree
  add_index "licencia", ["articulo_id"], name: "index_licencia_on_articulo_id", using: :btree
  add_index "licencia", ["cargo_id"], name: "index_licencia_on_cargo_id", using: :btree
  add_index "licencia", ["cargo_no_docente_id"], name: "index_licencia_on_cargo_no_docente_id", using: :btree

  create_table "localidads", force: true do |t|
    t.string   "nombre"
    t.integer  "region_id"
    t.integer  "cp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lote_impresions", force: true do |t|
    t.date     "fecha_impresion"
    t.text     "observaciones"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tipo_id"
  end

  create_table "lugar_pagos", force: true do |t|
    t.integer  "codigo"
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "materia", force: true do |t|
    t.integer  "codigo"
    t.string   "descripcion"
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

  create_table "periodo_asistencia", force: true do |t|
    t.string   "mes"
    t.integer  "anio"
    t.integer  "asistencia_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "periodo_asistencia", ["asistencia_id"], name: "index_periodo_asistencia_on_asistencia_id", using: :btree

  create_table "periodo_liq_cargos", force: true do |t|
    t.string   "mes"
    t.integer  "anio"
    t.integer  "altas_bajas_cargo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "periodo_liq_cargos", ["altas_bajas_cargo_id"], name: "index_periodo_liq_cargos_on_altas_bajas_cargo_id", using: :btree

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
    t.string   "apeynom"
  end

  create_table "plans", force: true do |t|
    t.integer  "codigo"
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "primaria_cargos", force: true do |t|
    t.string   "descripcion"
    t.integer  "codigo_nomen"
    t.integer  "cargo_inscrip_doc_id"
    t.integer  "inscripcion_id"
    t.integer  "funcion_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "primaria_cargos", ["cargo_inscrip_doc_id"], name: "index_primaria_cargos_on_cargo_inscrip_doc_id", using: :btree
  add_index "primaria_cargos", ["funcion_id"], name: "index_primaria_cargos_on_funcion_id", using: :btree
  add_index "primaria_cargos", ["inscripcion_id"], name: "index_primaria_cargos_on_inscripcion_id", using: :btree

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

  create_table "rubros", force: true do |t|
    t.integer  "escuela_id"
    t.float    "rubro_titulo"
    t.float    "rubro_concepto"
    t.float    "rubro_asis_perf"
    t.float    "rubro_ser_prest"
    t.float    "rubro_residencia"
    t.float    "rubro_gestion"
    t.float    "rubro_cursos"
    t.float    "ant_doc"
    t.float    "total"
    t.float    "promedio"
    t.integer  "persona_id"
    t.integer  "establecimiento_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "orden"
    t.string   "cargo"
    t.string   "region"
    t.integer  "cabecera"
    t.string   "nombre_apellido"
    t.string   "observaciones"
  end

  add_index "rubros", ["establecimiento_id"], name: "index_rubros_on_establecimiento_id", using: :btree
  add_index "rubros", ["persona_id"], name: "index_rubros_on_persona_id", using: :btree

  create_table "sexos", force: true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "situacion_revista", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "codigo"
    t.string   "descripcion"
    t.integer  "planta_pre"
    t.integer  "tipo_emp"
  end

  create_table "suplentes", force: true do |t|
    t.integer  "altas_bajas_hora_id"
    t.date     "fecha_desde"
    t.date     "fecha_hasta"
    t.text     "observaciones"
    t.string   "estado"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tipo_suplente"
  end

  add_index "suplentes", ["altas_bajas_hora_id"], name: "index_suplentes_on_altas_bajas_hora_id", using: :btree

  create_table "tipo_articulos", force: true do |t|
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tipo_documentos", force: true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "codigo"
  end

  create_table "titulo_personas", force: true do |t|
    t.integer  "titulo_id"
    t.integer  "persona_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "inscripcion_id"
  end

  add_index "titulo_personas", ["persona_id"], name: "index_titulo_personas_on_persona_id", using: :btree
  add_index "titulo_personas", ["titulo_id"], name: "index_titulo_personas_on_titulo_id", using: :btree

  create_table "titulos", force: true do |t|
    t.string   "nombre"
    t.integer  "persona_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "alcance"
    t.string   "tipotitulo"
    t.string   "region"
    t.text     "comentario"
    t.string   "cargo"
  end

  add_index "titulos", ["persona_id"], name: "index_titulos_on_persona_id", using: :btree

  create_table "turnos", force: true do |t|
    t.string   "descripcion"
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
