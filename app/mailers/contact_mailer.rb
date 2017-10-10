class ContactMailer < ApplicationMailer

    def contact_email(message)
        @nombre = message.name
        @email = message.email
        @mensaje = message.content
        mail(to: 'donatingoals@gmail.com', subject: 'Pregunta desde donatingoals')
    end

end
