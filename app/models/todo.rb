class Todo < ApplicationRecord
  belongs_to :user
  # acts_as_list :scope => :user
  def toggle_done
    self.done = (not self.done)
  end
  def self.suggest(loc,exclude=nil)
    r=YAML.load_file("#{Rails.root}/config/stodos/todos.#{loc}.yml")
    # r=YAML.load_file("#{Rails.root}/config/stodos/test.yml")
    r.each do |g|
      g['todos'].map!{ |d| Todo.new(:description=>d) }
      if (exclude) 
        # if (exclude.class == 'Array')
          g['todos'].reject! do |t|
            ! exclude.find{ |et| t.description == et.description }.nil? 
          end
        # else
        #   g['todos'].reject! { |t| t.description == exclude.description }
        # end
      end
    end
  end
end
