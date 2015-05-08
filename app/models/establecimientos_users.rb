class EstablecimientosUsers < ActiveRecord::Base
  belongs_to :establecimiento, :foreign_key => 'establecimiento_id', :class_name => 'Establecimiento'
  belongs_to :user, :foreign_key => 'user_id', :class_name => 'User'
end
