class UserWorker
	include Sidekiq::Worker
	sidekiq_options :retry => 10

	sidekiq_retry_in do |count|
		rand(600) * (count + 1) # (i.e. 10, 20, 30, 40, 50)
	end

	def perform(donation_id)
		@donation = Donation.find(donation_id)
		@user = User.find(@donation.user_id)

		if @user.id <= 114
			@user.update(saldo: @user.saldo + (@donation.value + (@donation.value*0.3)))
		else
		  	@user.update(saldo: @user.saldo + (@donation.value + (@donation.value*0.25)))
		end

		#Update all my parents
		@padre_1 = @user.ancestors(:at_depth => -1).first
		@referral_number = 3

		if (@user.last_donation_per_month(@padre_1).size > 0)
			@padre_1.update(saldo: @padre_1.saldo + (@donation.value*0.1))
			@padre_1.update(level_one_amount: @padre_1.level_one_amount + @donation.value)    
		end

			@padre_2 = @user.ancestors(:at_depth => -2).first
			@padre_3 = @user.ancestors(:at_depth => -3).first
			@padre_4 = @user.ancestors(:at_depth => -4).first
			@padre_5 = @user.ancestors(:at_depth => -5).first
			@padre_6 = @user.ancestors(:at_depth => -6).first

			if @padre_2
				if (@padre_2.total_value_donations_level(1) >= @referral_number) || (@padre_2.has_role? :lider )
					@padre_2.update(saldo: @padre_2.saldo + (@donation.value*0.05))
					@padre_2.update(level_two_amount: @padre_2.level_two_amount + @donation.value)  
				end   
			end
			
			if @padre_3
				if (@padre_3.total_value_donations_level(1) >= @referral_number) || (@padre_3.has_role? :lider )
					@padre_3.update(saldo: @padre_3.saldo + (@donation.value*0.03))
					@padre_3.update(level_three_amount: @padre_3.level_three_amount + @donation.value)  
				end   	
			end

			if @padre_4	
				
				if (@padre_4.total_value_donations_level(1) >= @referral_number) || (@padre_4.has_role? :lider )
					@padre_4.update(saldo: @padre_4.saldo + (@donation.value*0.015))
					@padre_4.update(level_four_amount: @padre_4.level_four_amount + @donation.value)  
				end  	
			end

			if @padre_5
				
				if (@padre_5.total_value_donations_level(1) >= @referral_number) || (@padre_5.has_role? :lider )
					@padre_5.update(saldo: @padre_5.saldo + (@donation.value*0.01))
					@padre_5.update(level_five_amount: @padre_5.level_five_amount + @donation.value)    
				end 
			end

			if @padre_6
				if (@padre_6.total_value_donations_level(1) >= @referral_number)|| (@padre_6.has_role? :lider )
					@padre_6.update(saldo: @padre_6.saldo + (@donation.value*0.001))
					@padre_6.update(level_six_amount: @padre_6.level_six_amount + @donation.value) 
				end    
			end   	
			                  
	end

	
end