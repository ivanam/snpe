class Funcion < ActiveRecord::Base


  DIRECTOR_CATEGORIAS = [ '206', '207', '210', '305', '306', '307', '310', '321', '322', '502', '503', '602', '603', '607', '610', '702', '703', '802', '803', '913', '914', '915', '950']

  VICEDIRECTOR_CATEGORIAS = [ '104', '108', '208', '308', '508', '608', '708', '808',  '916', '917', '918', '951']

  PEP_CATEGORIAS = [ '963', '964', '965']

  PRECEPTOR_CATEGORIAS = [ '944']

  MOT_CATEGORIAS = [ '313']

  SECRETARIO_CATEGORIAS = [ '930', '116', '928', '929', '930', '952', '953']

  BIBLIOTECARIO_CATEGORIAS = [ '113', '943', '954']

  def to_s
  	"#{ self.categoria }  -  #{self.descripcion}"
  end


  def self.cargos_equivalentes(categoria)
      if DIRECTOR_CATEGORIAS.include? categoria
        return DIRECTOR_CATEGORIAS
      elsif VICEDIRECTOR_CATEGORIAS.include? categoria
        return VICEDIRECTOR_CATEGORIAS
      else
        return categoria
      end
  end


  def self.cargos_jerarquicos
    jerarquicos = []
    DIRECTOR_CATEGORIAS.each do |c|
      jerarquicos << c
    end
    VICEDIRECTOR_CATEGORIAS.each do |c|
      jerarquicos << c
    end
    return jerarquicos
  end

  def self.cargos_especiales
    especiales = []
    DIRECTOR_CATEGORIAS.each do |c|
      especiales << c
    end
    VICEDIRECTOR_CATEGORIAS.each do |c|
      especiales << c
    end
    PEP_CATEGORIAS.each do |c|
      especiales << c
    end
    PRECEPTOR_CATEGORIAS.each do |c|
      especiales << c
    end
    MOT_CATEGORIAS.each do |c|
      especiales << c
    end
    SECRETARIO_CATEGORIAS.each do |c|
      especiales << c
    end
    BIBLIOTECARIO_CATEGORIAS.each do |c|
      especiales << c
    end
    return especiales
  end


end
