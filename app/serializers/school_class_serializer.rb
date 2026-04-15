class SchoolClassSerializer
  def self.call(school_class)
    {
      id: school_class.id,
      number: school_class.number,
      letter: school_class.letter,
      students_count: school_class.students_count
    }
  end
end
