require_relative '01_sql_object'

class Validator < SQLObject

  def self.validates(*args)
    options = args.pop

    define_method :errors do
      @errors ||= Hash.new { |k, v| k[v] = [] }
    end

    define_method :presence do |var|
      errors[:missing] << "'#{var}' not present" unless send(var)
    end

    define_method "validate" do
      args.each do |arg|
        presence(arg) if self.class.columns.include?(arg) && options[:presence]
      end
    end
  end

  def save
    @errors = Hash.new { |k, v| k[v] = [] }
    validate
    if errors.empty?
      puts "Save successful"
      true
    else
      puts errors.values.join(",")
      false
    end
  end

  def save!
    raise errors.to_s unless save
  end
end

class Cat < Validator
  validates :name, :owner_id, presence: true
  finalize!
end
