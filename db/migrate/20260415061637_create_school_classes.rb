class CreateSchoolClasses < ActiveRecord::Migration[7.1]
  def change
    create_table :school_classes do |t|
      t.integer :number, null: false
      t.string :letter, null: false
      t.integer :students_count, null: false, default: 0
      t.references :school, null: false, foreign_key: true

      t.timestamps
    end

    add_index :school_classes, [:school_id, :number, :letter], unique: true
  end
end
