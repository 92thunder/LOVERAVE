class CreateRegs < ActiveRecord::Migration
  def change
    create_table :regs do |t|
      t.string :regid
      t.float :x
      t.float :y

      t.timestamps
    end
  end
end
