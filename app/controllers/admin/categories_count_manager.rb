class Admin::CategoriesCountManager
  NUMBER_OF_CATEGORIES = 3

  attr_reader :project, :params

  def initialize(project_controller)
    @project = project_controller.project
    @params = project_controller.params
  end

  def number_of_empty_categories
    if for_new?(project)
      number_for_new
    elsif for_edit?(project)
      number_for_edit
    else
      number_in_change
    end
  end

  def for_new?(project)
    project.new_record? && project.errors.empty?
  end

  def for_edit?(project)
    project.persisted? && project.errors.empty?
  end

  def number_for_new
    NUMBER_OF_CATEGORIES
  end

  def number_for_edit
    NUMBER_OF_CATEGORIES - project.project_categories.count
  end

  def number_in_change
    category_entries = params[:project][:project_categories_attributes].values
    category_entries.count { |entry| entry['category_id'].empty? }
  end
end
