promo_a = Promo.create!(name: 'Black Friday', starting_date: Time.zone.today, ending_date: Time.zone.today + 30.days , discount_max: 10000, discount_percentage: 20, product_list: "notebooks, smartphones", usages_max: 10 )
promo_b = Promo.create!(name: 'Promo de Natal', starting_date: Time.zone.today, ending_date: Time.zone.today + 15.days, discount_max: 15000, discount_percentage: 15, product_list: "smartphones", usages_max: 50 )
promo_c = Promo.create!(name: 'Promo de Fim de Ano', starting_date: Time.zone.today, ending_date: Time.zone.today + 20.days, discount_max: 5000, discount_percentage: 10, product_list: "notebooks", usages_max: 100 )
promo_d = Promo.create!(name: 'Promo Relâmpago', starting_date: Time.zone.today, ending_date: Time.zone.today + 7.days, discount_max: 5000, discount_percentage: 10, product_list: "notebooks", usages_max: 150 )

