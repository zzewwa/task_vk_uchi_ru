class ToolsService
  def self.random_string(num)
    alphabet = [("a".."z"), ("A".."Z")].map(&:to_a).flatten
    (0...num).map { alphabet[rand(alphabet.length)] }.join
  end
end
