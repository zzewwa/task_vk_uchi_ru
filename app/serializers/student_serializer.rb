class StudentSerializer
  def self.call(student)
    {
      id: student.id,
      first_name: student.first_name,
      last_name: student.last_name,
      surname: student.surname,
      class_id: student.school_class_id,
      school_id: student.school_id
    }
  end
end
