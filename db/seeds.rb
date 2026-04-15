# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
school_1 = School.find_or_create_by!(name: "School #1")
school_2 = School.find_or_create_by!(name: "School #2")

[
	{ school: school_1, number: 1, letter: "A" },
	{ school: school_1, number: 1, letter: "B" },
	{ school: school_1, number: 2, letter: "A" },
	{ school: school_2, number: 3, letter: "A" }
].each do |attrs|
	SchoolClass.find_or_create_by!(
		school: attrs[:school],
		number: attrs[:number],
		letter: attrs[:letter]
	)
end

admin_class = SchoolClass.find_by!(school: school_1, number: 1, letter: "A")
admin_student = Student.find_or_initialize_by(
	first_name: "Admin",
	last_name: "System",
	surname: "User"
)
admin_student.school = school_1
admin_student.school_class = admin_class
admin_student.jwt_validation = ToolsService.random_string(32) if admin_student.jwt_validation.blank?
admin_student.save!
