class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      # Rails 8's authentication generator names this email_address (not
      # docs/03-data-model.md's "email") -- kept the generator's convention
      # rather than fight it; normalizes :email_address in the model still
      # satisfies "downcased".
      t.string :email_address, null: false
      t.string :password_digest, null: false
      t.string :name, null: false
      # प्रशासक / संपादक / वार्ताहर -- docs/00-project-brief.md, "Roles".
      # Literal integer default (least-privileged), not User.roles.fetch(...)
      # -- migrations shouldn't depend on the model class's current
      # definition. Mapping is declared explicitly in the User model's enum.
      t.integer :role, null: false, default: 2
      # Deactivating (not deleting) a departed staff member's account keeps
      # their authorship on past published articles intact -- see
      # prompts/phase-07-admin-auth.md's audit trail requirement.
      t.boolean :active, null: false, default: true
      t.datetime :last_seen_at

      t.timestamps
    end
    add_index :users, :email_address, unique: true
  end
end
