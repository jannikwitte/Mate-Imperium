class RenameCompanyDescriptionToBasicKnowledge < ActiveRecord::Migration[7.1]
  def change
    rename_column :posts, :company_description, :basic_knowledge
  end
end
