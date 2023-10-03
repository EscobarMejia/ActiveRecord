require 'sqlite3'
require 'active_record'
require 'byebug'


ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'customers.sqlite3')
# Mostrar consultas en la consola.
# Comenta esta linea para desactivar la visualización de consultas SQL sin formato.
ActiveRecord::Base.logger = Logger.new(STDOUT)

class Customer < ActiveRecord::Base
  def to_s
    "  [#{id}] #{first} #{last}, <#{email}>, #{birthdate.strftime('%Y-%m-%d')}"
  end

  # NOTA: Cada uno de estos se puede resolver por completo mediante llamadas de ActiveRecord.
  # No deberías necesitar llamar a las funciones de  Ruby para ordenar, filtrar, etc.
  def self.any_candice
    where(first: 'Candice')
  end

  # Método para encontrar clientes con direcciones de correo electrónico válidas
  def self.with_valid_email
    where("email LIKE '%@%'")
  end

  # Método para encontrar clientes con correos electrónicos que contienen ".org"
  def self.with_dot_org_email
    where("email LIKE '%.org%'")
  end

  # Método para encontrar clientes con correo electrónico no válido pero que no esté en blanco
  def self.with_invalid_email
    where("email NOT LIKE '%@%' AND email != ''")
  end

  # Método para encontrar clientes con correo electrónico en blanco
  def self.with_blank_email
    where("TRIM(email) = '' OR email IS NULL")
  end

  # Método para encontrar clientes nacidos antes del 1 de enero de 1980
  def self.born_before_1980
    where("birthdate < ?", Date.new(1980, 1, 1))
  end

  # Método para encontrar clientes con correo electrónico válido y nacidos antes del 1 de enero de 1980
  def self.with_valid_email_and_born_before_1980
    with_valid_email.born_before_1980
  end

  # Método para encontrar clientes cuyos apellidos comienzan con "B" y ordenarlos por fecha de nacimiento
  def self.last_names_starting_with_b
    where("last LIKE 'B%'").order(:birthdate)
  end

  # Método para encontrar los 20 clientes más jóvenes, en cualquier orden
  def self.twenty_youngest
    order(birthdate: :desc).limit(20)
  end
  # Método para actualizar la fecha de nacimiento de Gussie Murray
  def self.update_gussie_murray_birthdate
    gussie = find_by(first: 'Gussie', last: 'Murray')
    gussie.update(birthdate: Time.parse('2004-02-08'))
  end

  # Método para cambiar todos los correos electrónicos no válidos a blanco
  def self.change_all_invalid_emails_to_blank
    where("email NOT LIKE '%@%'").update_all(email: '')
  end

  # Método para eliminar al cliente Meggie Herman
  def self.delete_meggie_herman
    where(first: 'Meggie', last: 'Herman').delete_all
  end

  # Método para eliminar a todos los clientes nacidos antes del 31 de diciembre de 1977
  def self.delete_everyone_born_before_1978
    where("birthdate < ?", Date.new(1978, 1, 1)).delete_all
  end
end
