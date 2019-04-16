
namespace :app do
  desc "Add categories"
  
    task :set_categories => [ :environment ] do
      
    Category.delete_all
    Category.create(:name => 'Science') 
    Category.create(:name => 'Security')
    Category.create(:name => 'Hacking')
    Category.create(:name => 'Travel')
    
  end
end