ActiveAdmin.register User, as: 'Genius' do
  permit_params :avatar, :first_name, :last_name, :username, :email, :email2, :cell, :password, :password_confirmation, :stipend, :address, :benchmarks, avatar_attributes: [:_destroy]
  menu priority: 4
  config.batch_actions = true
  #active_admin_importable


      index do
        selectable_column
        id_column
        column :first_name
        column :last_name
        column :email
        column :email2
        column :username
        column :address
        column :cell
        column :projects
        column :sign_in_count
        column :created_at
        image_column :avatar, style: :thumb

        actions
      end



  filter :genius
  filter :cohort_id
  filter :city
  filter :stipend
  filter :benchmarks
  filter :username
  filter :feature
  filter :sign_in_count
  filter :created_at


  form do |f|
    f.inputs do
      f.input :genius
      f.input :cohort_id
      f.input :city
      f.input :cell
      f.input :email
      f.input :password, input_html: { autocomplete: "new-password" }
      f.input :email2
      f.input :username
      f.input :avatar, as: :file
      if f.object.avatar.present?
        f.semantic_fields_for :avatar_attributes do |avatar_fields|
         avatar_fields.input :_destroy, as: :boolean, label: 'Delete?'
       end
     end
   end
    f.actions
        end

      form "Projects" do |a|
        a.has_many :projects,allow_destroy: true,
                              new_record: true do |a|
        a.input :app_name
        a.input :coding
        a.input :project_details
        a.input :start_date
        a.input :github

         end
       end

      #a.actions


      sidebar "Attendance Details", only: :show do
        attributes_table_for genius, :start_date, :start_date, :created_at
      end

      sidebar "Project History", only: :show do
        attributes_table_for genius do
          #row("Total Projects") { genius.projects.complete.count }
          row("Total Value") do

        end
      end
   end
 end