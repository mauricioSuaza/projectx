class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, 
         :recoverable, :rememberable, :trackable, :validatable, :lockable

  has_many :donations
  has_many :requests
  before_save :set_saldo_zero
  
  def set_saldo_zero
    self.saldo ||= 0
  end
  
  
  def send_donation (value)
  
    #valor ultimas solicitudes
    # pedi = { "uno": 100, "dos": 100, "tres": 100 , "cuatro": 200 }
    
    #Bloque de las ultimas solicitudes que aun no se han completado entre las cuales se va a repartir la donación
    block_size = 5
    block = Request.where(requested: "waiting")
    block = block.order('created_at DESC').last(block_size)

    #valor a entregar por transacción
   # repartir = {"uno": 0, "dos": 0, "tres": 0, "cuatro": 0 }
 
    transaction_values = [0, 0, 0, 0, 0]
    
    #estado de cada request
    estado = [false,false,false,false,false]
    
    donation_value = value.round() #valor de la donacion ingresada  
    
    saldo = value.round()  #saldo lo que va quedando de la donacion mientras se reparte originalmente es el valor completo
    
    residuo = 0 #valor pendiente por entregar de la donación, campo pending de la donación

    donation_state = 0
    #crear un array con los valores solicitados en cada request
    request_values = Array.new
    
    block.each do |req|
      #si estoy en el bloque mi valor solicitado es cero
      if req.user_id != self.id
        
        request_values << req.pending 
      else
        request_values << 0 
      end
    end
    
    #pequeños valores entre los que se va a repartir la transacción
    #percentage = (request_values.min*0.5).round()
    percentage = 1
    
      while (saldo > 0)  #mientras haya aun saldo por repartir
        
        if(saldo >= percentage) #si el saldo que haya disponible es mayor al porcentaje que se reparte
          
           transaction_values.each_with_index{ |val, i| #itero sobre el valor para cada transacción. 
           
            puts "i is #{i}"
            #si el valor solocitado en la transacción  es mayor al valor que ya se ha dado mas el porcentaje
            if (saldo >= percentage && (request_values[i] >= (transaction_values[i] +  percentage)))
              
              #se aumenta el valor a trasnferir
              transaction_values[i] =  transaction_values[i] + percentage
              
              #se disminuye el saldo
              saldo = saldo - percentage
              
             p "El valor del request #{i}  es #{request_values[i]}"
             p "La transferencia del request #{i}  tiene #{transaction_values[i]}"
              
            #de lo contrario si el valor solicitado ya es igual al valor de la transacción
            elsif (transaction_values[i] +  percentage > request_values[i] && request_values[i] >     transaction_values[i])
              
              #percentage = percentage * 0.5
              puts "percentage is #{percentage}"
              if percentage>2
                percentage = percentage - 1
              else
                percentage = 1
              end
              #percentage = request_values[i] - transaction_values[i]
            end
             
            if(request_values[i] == transaction_values[i])
              p "Se completo la solicitud #{i}"
              estado[i] = true 
              block[i].requested = 1
              block[i].save
            end
             
            }
              
            if (estado.all? {|x| x == true})
              # sacar todas las transacciones y renovar el bloque
              p "Se completaron todaaaas XXXXXXXXXXXX"
              residuo = saldo
              saldo = 0
            end
              
        else
          percentage = saldo/block_size
        end
             
      end

      #Si no ha sobrado nada el estado de la donacion va a completo
      if residuo==0
        donation_state = 1
      end
    
      #posterior al calculo crear la donación y las transferencias. 
      
      donation = self.donations.new(value: donation_value, pending: residuo, status: donation_state)

      if donation.save
          #creo las transacciones
          transaction_values.each_with_index do |val, i|
            p "El valor solicitado del request #{i}  es #{request_values[i]}"
            p "La transferencia del request #{i}  tiene #{transaction_values[i]}"
          
            #si la transacción es a mi mismo no se debe generar
            if  block[i].user_id != self.id
              transaction = donation.transactions.create(value: transaction_values[i], sender_id: donation.user_id, receiver_id: block[i].user_id, request_id: block[i].id)
            
              #Hacer los updates respectivos del request
              #Update el valor que queda pendiente por pedir del request
              block[i].pending = block[i].pending - transaction_values[i]
              #si el  valor pendiente del request es igual a 0 
              block[i].save
            end
            
          end  
      end

      #revisar si todo esta en orden despues de que se creo cada transacción.
      donation.transactions.each_with_index do |val, i|  
         p "para request #{i}"
         p "El usuario que solicito la transacction en el bloque #{i}  es #{block[i].user_id}"
         p "El usuario que recibirá la transaccon #{i}  es #{donation.transactions[i].receiver_id}"
         p "El valor solicitado en el bloque #{i}  es #{block[i].value}"
         p "El valor a consignar #{i}  es #{donation.transactions[i].value}" 
         p "El valor pendiente por consignar en #{i}  es #{block[i].pending}" 
      end
    
      puts "block status #{block}"
      #check if requests are completed 

    #method end
  end


end
    



