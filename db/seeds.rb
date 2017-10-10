# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)




  for i in 0..24
    user = User.new(
      email:"test#{i}@test.com",
      password: "password#{i}",
      name:"user#{i}",
      phone: "#{i}666",
      btc: "#{i*2}3231", 
      saldo: rand(100..200))
    user.skip_confirmation!
    user.save
  end


