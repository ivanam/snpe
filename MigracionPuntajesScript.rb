# Script para migracion de puntajes de docentes, a partir de archivo exel.
# Fecha creacion: 21 sep 2018
# Fecha de migracion: ---
# Ejecutar: ruby MigrarPuntajesScript.rb print migrate force
# Este script puede ser configurado para:
# - leer un determinado archivo .xls
# - configurar las columnas a parsear (indices deben ser validos)
# - la conexion a la base de datos para insertar los puntajes (Rubro)

require 'spreadsheet'
require 'active_record'

filename = './example.xls'
workbook = Spreadsheet.open filename
worksheets = workbook.worksheets

ActiveRecord::Base.establish_connection(
  adapter:  'mysql2',
  host:     '127.0.0.1',
  database: 'snpe',
  username: 'root',
  #password: 'root'
  password: 'zzpregasep'
)

# Clase usada para parsear y validar la informacion del exel.
class DataExel
    attr_accessor :nombre
    attr_accessor :dni
    attr_accessor :puntaje
    attr_accessor :cargo
    attr_accessor :region
    attr_accessor :cabecera

    def clean_puntaje
      puntaje = self.puntaje.to_s
      puntaje = puntaje.include?(',') ? (puntaje.gsub! ',', '.') : puntaje
      puntaje = puntaje.to_f
      puntaje = puntaje.round(2)
      self.puntaje = puntaje
    end

    def clean_dni
      dni = self.dni.to_s
      dni = dni.include?(',') ? (dni.gsub! ',', '') : dni 
      dni = dni.include?('.') ? (dni.gsub! '.', '') : dni
      dni = dni.to_i
      self.dni = dni
    end

    def clean_cargo 
      self.cargo = "107"
    end

    def clean_cabecera
      cabecera = self.cabecera.to_s
      cabecera = self.cabecera.to_i
      self.cabecera = cabecera
    end

    def isValid
      self.clean_cargo
      self.clean_dni
      self.clean_puntaje
      self.clean_cabecera
      if self.nombre.nil? or self.nombre.empty? or
        self.dni.nil? or
        self.puntaje.nil? or self.puntaje == 0
        self.cargo.nil? or self.cargo.empty?
        self.region.nil? or self.region.empty?
        return false
      end
      return true
    end

    def to_s
      "(#{self.cargo}) #{self.dni} #{self.nombre} -> #{self.puntaje} #{self.region} / #{self.cabecera}"
    end  
end

# indice (numero de columna a partir de 0) de los datos que quieren buscar
INDICES = {
  'DNI' => 4,
  'REGION' => 1,
  'CABECERA' => 2,
  'CARGO' => 3,
  'PUNTAJE' => 13,
  'NOMBRE' => 3
}

result = []
worksheets.each do |worksheet|
  worksheet.rows.each do |row|
    row_cells = row.to_a.map{ |v| v.methods.include?(:value) ? v.value : v }
    d = DataExel.new
    d.nombre = String(row_cells[INDICES['NOMBRE']])
    d.dni = String(row_cells[INDICES['DNI']])
    d.puntaje = String(row_cells[INDICES['PUNTAJE']])
    d.cargo = String(worksheet.name)
    d.region = String(row_cells[INDICES['REGION']])
    d.cabecera = String(row_cells[INDICES['CABECERA']])
    result.push(d)
  end
end

# Modelos rails para facilitar las consultas a la base de datos.
class Persona < ActiveRecord::Base
  self.table_name = "personas"
  def to_s
      "#{ self.nro_documento }  | #{ self.apeynom }"
  end
end
class Inscripcion < ActiveRecord::Base
  self.table_name = "inscripcions"
end
class Funcion < ActiveRecord::Base
  self.table_name = "funcions"
end
class CargoInscipDocs < ActiveRecord::Base
  self.table_name = "cargo_inscrip_docs"
end
class Region < ActiveRecord::Base
  self.table_name = "regions"
end
class Rubro < ActiveRecord::Base
  self.table_name = "rubros"
end

# muestro los datos parseados por consola.
if ARGV.include?('print')
  count = 0
  result.each do |exel|
    if exel.isValid
      puts exel.to_s
      count += 1
    end
  end 
  puts "Total de registros: #{count}"
end

# transaccion sql para insertar tuplas a la base de datos.
if ARGV.include?('migrate')
  puts "Migrando ..."
  one_error = false
  total_records = 0
  Rubro.transaction do
    result.each do |dataExcel|
      if dataExcel.isValid
        persona = Persona.where(nro_documento: dataExcel.dni).first
        region = Region.where(nombre: dataExcel.region).first
        cargo = Funcion.where(categoria: dataExcel.cargo).first
        rubro = Rubro.new
        
        if persona.nil?
          rubro.errors[:base] << "DNI #{dataExcel.dni} con nombre #{dataExcel.nombre} no encontrado en la base"
        end
        if region.nil?
          rubro.errors[:base] << "REGION #{dataExcel.region} no se encontro en la base"
        end
        if cargo.nil?
          rubro.errors[:base] << "CARGO #{dataExcel.cargo} no se encontro en la base"
        end

        if rubro.errors.size > 0
          rubro.errors.full_messages.each do |e| 
            puts e
            one_error = true
          end
        else
          Rubro.create!(
            total: dataExcel.puntaje,
            cabecera: dataExcel.cabecera,
            persona_id: persona.id, 
            region: region.id,
            funcion_id: cargo.id
          )
          total_records += 1
        end
      end
    end
    # con la opcion force se insertan los registros validos, no los invalidos.
    if one_error and not ARGV.include?('force')
        puts "Ejecutando Rollback ..."
        raise ActiveRecord::Rollback
    else
      puts "#{total_records} registros guardados en la base de datos."
    end
  end  
end

# se muestra por consola los totales de registros insertados por cargos.
if ARGV.include?('count')
  cargos = {}
  result.each do |r| 
    if r.isValid
      if cargos[r.cargo]
        cargos[r.cargo] += 1
      else
        cargos[r.cargo] = 1
      end
    end
  end
  cargos.each do |k, v|
    puts "Cargo #{k} Registros #{v}" 
  end
  puts "Total de registros #{result.length}"
end