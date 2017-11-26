class NotificationMailer < ApplicationMailer

    def mass_email(user)
        @user = user
        mail(to: @user.email, subject: 'Aviso importante comunidad donatingoals')
    end
    
end
