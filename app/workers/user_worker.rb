class UserWorker
	include Sidekiq::Worker
	sidekiq_options :retry => 10

	sidekiq_retry_in do |count|
                rand(600) * (count + 1) # (i.e. 10, 20, 30, 40, 50)
        end

        def perform(donation_id)
                @donation = Donation.find(donation_id)
                @user = User.find(@donation.user_id)
                @user.update(saldo: @user.saldo + (@donation.value + (@donation.value*0.3)))   
	end
end