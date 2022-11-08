User.destroy_all
Admin.destroy_all

FactoryBot.build(:user).save(validate: false)
FactoryBot.create(:admin)
