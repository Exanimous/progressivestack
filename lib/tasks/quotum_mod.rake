namespace :quotum_mod do
  desc "Convert quotum name column values to downcase"
  task name_to_downcase: :environment do
    Quotum.all.each do |quotum|
      quotum.update(name: quotum.name.downcase)
    end
  end
end
