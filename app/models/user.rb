class User < ApplicationRecord
  rolify

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable

  has_many :chats, :foreign_key => :sender_id
  has_many :donations, dependent: :destroy
  has_many :requests, dependent: :destroy
  has_many :notifications, dependent: :destroy


  before_save :set_saldo_zero
 # acts_as_tree order: "email"
  has_ancestry cache_depth: true
  #extend ActsAsTree::TreeView
  attr_accessor :refferal, :terms

  validates :name, presence: true
  validates :phone, presence: true
  validates :btc, presence: true

  after_create :assign_default_role

  filterrific(
    default_filter_params: { },
    available_filters: [
    :search_name, 
    :with_id
    ]
  )


  scope :search_name, lambda { |query|
     return nil  if query.blank?
  
     # condition query, parse into individual keywords
     terms = query.downcase.split(/\s+/)
  
     # replace "*" with "%" for wildcard searches,
     # append '%', remove duplicate '%'s
     terms = terms.map { |e|
       (e.gsub('*', '%') + '%').gsub(/%+/, '%')
     }
     # configure number of OR conditions for provision
     # of interpolation arguments. Adjust this if you
     # change the number of OR conditions.
     num_or_conds = 2
     where(
       terms.map { |term|
         "(LOWER(users.name) LIKE ? OR LOWER(users.email) LIKE ? )"
       }.join(' AND '),
       *terms.map { |e| [e] * num_or_conds }.flatten
     )
  }

  scope :with_id, lambda { |query_id|
    where('users.id = ?', query_id)
  }

  def set_saldo_zero
    self.saldo ||= 0
  end


  def update_test
    self.update(name: 'test')
  end

  def assign_default_role
    self.add_role(:user) if self.roles.blank?
  end

  def unseen_notifications
    self.notifications.where("message_id IS NOT NULL").where(read: false).count
  end
  

  def send_donation (value)

    

    #Configuración de variables para inicializar la donación
    request = get_oldest_request() #Tomar el request mas antiguo

    donation_value = value.round() #valor de la donacion ingresada  

    #calculo de valores generados para el owner

    owner_user = User.with_role(:owner).order("RANDOM()").last

    owner_tran_val = (donation_value*0.1).ceil;

    residuo = donation_value - (owner_tran_val) #valor pendiente por entregar de la donación, campo pending de la donación

    donation_state = 0  #estado de la donación, si ya ha sido repartida o aun no. 
    
    donation = self.donations.new(value: donation_value, pending: residuo, status: donation_state)
    
    #revisar resultados del metodo mientras haya residuo y la cola se puede actualziar con transacciones pendientes volver a repartir
    if donation.save
      #crear transaction al owner 

      #transaccion generada para el owner
      transaction = donation.transactions.create(value: owner_tran_val, sender_id: self.id, receiver_id: owner_user.id)
      TransactionMailer.transaction_with_owner(transaction).deliver_later
      TransactionWorker.perform_in(48.hours, transaction.id)


      while((donation.pending > 0) && request )

          create_transaction(request, donation, residuo) 
          #Funcion para realizar el envio con las variables configuradas
          request = get_oldest_request() #Tomar el request mas antiguo
    
      end
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
    TransactionMailer.transaction_created_reciver(transaction).deliver_later
    TransactionMailer.transaction_created_sender(transaction).deliver_later
    TransactionWorker.perform_in(48.hours, transaction.id)

    #Creates notification for receiver incase exist.
    notification = create_notification(transaction)

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


  def get_notificaations
    self.notifications.order('created_at DESC').where(read: false).where("message_id is NULL").count
  end

  def messages_notifications
    self.notifications.order('created_at DESC').where(read: false).where("message_id is NOT NULL").count
  end

  def get_pending_donation
    block = Donation.where.not(user_id: self.id)
    block = block.where(status: "pending")
    block.order('created_at DESC').last()
  end


  def create_notification(data)
    @receiver = User.find(data.receiver_id)
    if !data.nil? 
      @receiver.notifications.create(owner_id: data.sender_id, value: data.value, read: false)
    end
  end

  def last_donation_per_month(user)
    user.donations.where('created_at > ?', 30.days.ago).where(status: "completed")
  end

  def total_value_donations_level(level)
    childrens_donation_500 = 0 
    self.descendants(at_depth: level).each do |son|
      total = 0
      last_donation_per_month(son).each do |donation|
        total = total + donation.value
      end
      if total >= 500
        childrens_donation_500 =  childrens_donation_500 + 1 
      end 
    end
    return childrens_donation_500
  end

  def descendants_email(level)
    emails = []
    descendants(at_depth: level).each do |son|
      emails.push(son.email)
    end
    emails.count > 0 ? emails : "no tiene referidos en el nivel #{level}"
  end
end
    



