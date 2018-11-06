# Script para migracion de puntajes de docentes, a partir de archivo exel.
# Fecha creacion: 21 sep 2018
# Fecha de migracion: ---
# Ejecutar: ruby MigracionPuntajesScript.rb print migrate force
# Este script puede ser configurado para:
# - leer un determinado archivo .xls
# - configurar las columnas a parsear (indices deben ser validos)
# - la conexion a la base de datos para insertar los puntajes (Rubro)

require 'spreadsheet'
require 'active_record'

filename = './dataset.xls'
workbook = Spreadsheet.open filename
worksheets = workbook.worksheets

ActiveRecord::Base.establish_connection(
  adapter:  'mysql2',
  host:     '127.0.0.1',
  database: 'snpe',
  username: 'root',
  password: 'root'
  #password: 'zzpregasep'
)

# Clase usada para parsear y validar la informacion del exel.
class DataExel
    attr_accessor :nombre
    attr_accessor :dni
    attr_accessor :puntaje
    attr_accessor :cargo
    attr_accessor :region
    attr_accessor :cabecera
    attr_accessor :titular


    def clean_puntaje
      puntaje = self.puntaje.to_s
      puntaje = puntaje.include?(',') ? (puntaje.gsub! ',', '.') : puntaje
      puntaje = puntaje.to_f
      puntaje = puntaje.round(2)
      self.puntaje = puntaje
    end

    def clean_dni
      dni = self.dni.to_s
      dni = dni.scan(/\d/).join('')
      dni = dni.to_i
      if dni.to_s.length != 8
        puts "DNI INCORRECTO (#{dni}) (#{self.nombre})"
        dni = nil
      end      
      dni = dni.to_i
      self.dni = dni
    end

    def clean_cargo 
      cargo = self.cargo
      self.cargo = cargo
    end

    def clean_cabecera
      cabecera = self.cabecera.to_s
      cabecera = self.cabecera.to_i
      self.cabecera = cabecera
    end

    def clean_titular
      titular = self.titular.to_s
      if titular != '1' && titular != '0'
        titular = nil
      end
      self.titular = titular
    end

    def isValid
      self.clean_titular
      self.clean_cargo
      self.clean_dni
      self.clean_puntaje
      self.clean_cabecera
      if self.nombre.nil? or self.nombre.empty? or
        self.dni.nil? or
        self.puntaje.nil? or self.puntaje == 0
        self.cargo.nil? or self.cargo.empty?
        self.region.nil? or self.region.empty? or self.titular.nil?
        return false
      end
      return true
    end

    def to_s
      "(#{self.cargo}) #{self.titular} #{self.dni} #{self.nombre} -> #{self.puntaje} #{self.region} / #{self.cabecera}"
    end  
end

# indice (numero de columna a partir de 0) de los datos que quieren buscar
INDICES = {
  'DNI' => 5,
  'REGION' => 1,
  'CABECERA' => 2,
  'CARGO' => 6,
  'PUNTAJE' => 7,
  'NOMBRE' => 4,
  'TITULAR' =>3
}

result = []
worksheets.each do |worksheet|
  worksheet.rows.each do |row|
    row_cells = row.to_a.map{ |v| v.methods.include?(:value) ? v.value : v }
    d = DataExel.new
    d.nombre = String(row_cells[INDICES['NOMBRE']])
    d.dni = String(row_cells[INDICES['DNI']])
    d.puntaje = String(row_cells[INDICES['PUNTAJE']])
    d.cargo = String(row_cells[INDICES['CARGO']])
    d.region = String(row_cells[INDICES['REGION']])
    d.cabecera = String(row_cells[INDICES['CABECERA']])
    d.titular = String(row_cells[INDICES['TITULAR']])

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
class Juntafuncion < ActiveRecord::Base
  self.table_name = "juntafuncions"
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
invalids = []

# muestro los datos parseados por consola.
if ARGV.include?('print')
  count = 0
  result.each do |exel|
    if exel.isValid
      puts exel.to_s
      count += 1
    else
      invalids.push(exel)
    end
  end 
  puts "Total de registros: #{count}"
end
puts "NOT VALID .."
if ARGV.include?('print')
  count = 0
  invalids.each do |exel|
    puts exel.to_s    
  end 
end

def crear_persona(dni, nombre)
  puts "creando Persona #{dni} #{nombre}"
  return Persona.create(apeynom: nombre, nro_documento: dni)
end
def crear_cargo(descript)
  puts "creando cargo #{descript}"
  return Juntafuncion.create(descripcion: descript)
end
# transaccion sql para insertar tuplas a la base de datos.
if ARGV.include?('migrate')
  puts "Migrando ..."
  one_error = false
  total_records = 0
  total_personas = 0
  total_cargos = 0
  Rubro.transaction do
    result.each do |dataExcel|
      if dataExcel.isValid
        persona = Persona.where(nro_documento: dataExcel.dni).first
        region = Region.where(nombre: dataExcel.region).first
        juntacargo = Juntafuncion.where(descripcion: dataExcel.cargo).first
        rubro = Rubro.new
        
        if persona.nil?
          persona = crear_persona(dataExcel.dni, dataExcel.nombre)
          total_personas +=  1
          #rubro.errors[:base] << "DNI #{dataExcel.dni} con nombre #{dataExcel.nombre} no encontrado en la base"
        end
        if region.nil?
          rubro.errors[:base] << "REGION #{dataExcel.region} no se encontro en la base"
        end
        
        if juntacargo.nil?
          juntacargo = crear_cargo(dataExcel.cargo)
          total_cargos += 1
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
            region_id: region.id,
            funcion_id: nil,
            juntafuncion_id: juntacargo.id,
            titular: dataExcel.titular
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
      puts "#{total_records} rubros guardados en la base de datos."
      puts "#{total_personas} personas guardadas en la base de datos."
      puts "#{total_cargos} cargos guardados en la base de datos."
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