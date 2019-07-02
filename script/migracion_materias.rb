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

filename = './materias.xls'
workbook = Spreadsheet.open filename
worksheets = workbook.worksheets

ActiveRecord::Base.establish_connection(
  adapter:  'mysql2',
  host:     '127.0.0.1', # 172.16.0.15
  database: 'snpe', # snpedevelop
  username: 'root', # root
  password: 'root' # klP7879#1
  #password: 'zzpregasep'
)

# Clase usada para parsear y validar la informacion del exel.
class DataExel
    attr_accessor :codigo
    attr_accessor :descripcion

    def clean_nombre
      codigo = self.codigo.to_i
      self.codigo = codigo
    end

   def clean_desc
      descripcion = self.descripcion.to_s
      self.descripcion = descripcion
    end  
end

# indice (numero de columna a partir de 0) de los datos que quieren buscar
INDICES = {
  'CODIGO' => 0,
  'DESCRIPCION' => 1
}

result = []
worksheets.each do |worksheet|
  worksheet.rows.each do |row|
    row_cells = row.to_a.map{ |v| v.methods.include?(:value) ? v.value : v }
    d = DataExel.new
    d.codigo = String(row_cells[INDICES['CODIGO']])
    d.descripcion = String(row_cells[INDICES['DESCRIPCION']])
 

    result.push(d)
  end
end

class Materium < ActiveRecord::Base
  self.table_name = "materia"
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

# transaccion sql para insertar tuplas a la base de datos.
if ARGV.include?('migrate')
  puts "Migrando ..."
  one_error = false
  Materium.transaction do
    result.each do |dataExcel|
      if dataExcel.isValid
        if Materium.where(codigo: dataExcel.codigo).first == nil
        materia = Materium.new
        Materium.create!(
            codigo: dataExcel.codigo,
            descripcion: dataExcel.descripcion,
          )
        end
      end
    end
  end  
end
