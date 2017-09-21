# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



=begin
  for i in 0..24
    user = User.new(
      email:"test#{i}@test.com", 
      password: "password#{i}",
      saldo: rand(100..200))
    user.skip_confirmation!
    user.save
    user.requests.create(value: rand(80..200))
  end
=end



  User.first(3).each do |user|
    
    user.requests.create(value: rand(1..8))
    
  end


