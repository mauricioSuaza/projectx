class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, 
         :recoverable, :rememberable, :trackable, :validatable, :lockable

  has_many :chats, :foreign_key => :sender_id
  has_many :donations
  has_many :requests
  before_save :set_saldo_zero
  acts_as_tree order: "email"
  extend ActsAsTree::TreeView
  attr_accessor :refferal



  def set_saldo_zero
    self.saldo ||= 0
  end
  
  
  def send_donation (value)

    #Configuración de variables para inicializar la donación
  
    request = get_oldest_request() #Tomar el request mas antiguo

    donation_value = value.round() #valor de la donacion ingresada  
    
    residuo = donation_value #valor pendiente por entregar de la donación, campo pending de la donación

    donation_state = 0  #estado de la donación, si ya ha sido repartida o aun no. 
    
    donation = self.donations.create(value: donation_value, pending: residuo, status: donation_state)
    
    #revisar resultados del metodo mientras haya residuo y la cola se puede actualziar con transacciones pendientes volver a repartir

    while((donation.pending > 0) && request )

        create_transaction(request, donation, residuo) 
        #Funcion para realizar el envio con las variables configuradas
        request = get_oldest_request() #Tomar el request mas antiguo
  
    end

    donation.id

  end
  
  
  def create_transaction(request, donation, residuo)
    #repartir la donación en el request
    #Inicializar valores para calcular la transacción
    #valor a entregar por transacción 
    transaction_value = 0
    #estado del  request
    request_state = 0
    #estado de la donacion
    donation_state = 0

    if request.pending > donation.pending || request.pending == donation.pending

       transaction_value = donation.pending
       residuo = 0

    elsif request.pending < donation.pending

       transaction_value = request.pending
       residuo = donation.pending - transaction_value
       
    end
    #crear la transacción
    transaction = donation.transactions.create(value: transaction_value, sender_id: donation.user_id, receiver_id: request.user_id, request_id: request.id)
   
    #hacer update de la donación
    #Actualizar estado de la donacion 
    if residuo==0
      donation_state = 1
    end

    donation.update(pending: residuo, status: donation_state)

    #actualizar valores  del request  
    pending = request.pending - transaction_value

    if pending == 0 
      request_state = 1
    end

    request.update(pending: pending, requested: request_state)

    #imprimir valores al final del proceso

    p "El usuario que solicito la transacción  #{request.user_id}"
    p "El usuario que recibirá la transaccon  es  #{transaction.receiver_id}"
    p "El valor solicitado es #{request.value}"
    p "El valor a consignar es #{transaction.value}" 
    p "El valor pendiente del request es #{request.pending}" 
    p "El residuo de la donación es  #{donation.pending}"
    p "El estado del request es #{request.requested}"
    p "El estado de la donación es #{donation.status}"

  end
        
  def get_oldest_request
    
    block = Request.where.not(user_id: self.id)
    block = block.where(requested: "waiting")
    block.order('created_at DESC').last()

  end

  def request_donation(value)

    request_value = value.round()
    residuo = request_value #valor pendiente por ser requerido del request
    request_state = 0  #estado del request si aun no ha sido asignada

    #creo el request con el valor asignado
    request = self.requests.create(value: request_value, pending: residuo)

    #busco si hay donaciones pendientes por repartir
    donation =  get_pending_donation

    self.update(saldo: self.saldo - request_value)
    
    if donation

      while((request.pending > 0) && donation )
          create_transaction(request, donation, residuo) 
          #revisar si aun hay donaciones que puedan repartir
          donation =  get_pending_donation
      end

    end

  end

  def get_pending_donation
  
    block = Donation.where.not(user_id: self.id)
    block = block.where(status: "pending")
    block.order('created_at DESC').last()

  end

end
    



