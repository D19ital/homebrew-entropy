# A narrow DSL contract test, not a substitute for Homebrew on macOS.
class Definition
  attr_reader :values
  def initialize(cpu)
    @cpu = cpu
    @values = {}
  end

  def cask(token, &block)
    raise "Unexpected cask token" unless token == "entropy"
    instance_eval(&block)
  end

  def arch(**options)
    return @architecture if options.empty?
    @architecture = options.fetch(@cpu)
  end

  def version(value = nil)
    return @values.fetch(:version) if value.nil?
    @values[:version] = value
  end

  def sha256(**options)
    @values[:sha256] = options.fetch(@cpu)
  end

  def depends_on(value)
    @values[:depends_on] = value
  end

  [:url, :name, :desc, :homepage, :app].each do |field|
    define_method(field) { |value| @values[field] = value }
  end
end

path = File.expand_path("../Casks/entropy.rb", __dir__)
{arm: "arm64", intel: "x86_64"}.each do |cpu, architecture|
  definition = Definition.new(cpu)
  definition.instance_eval(File.read(path), path)
  values = definition.values
  raise "Invalid version" unless /\A\d+\.\d+\.\d+\z/.match?(values.fetch(:version))
  expected = "https://github.com/ergohaven/entropy/releases/download/v#{values[:version]}/entropy-v#{values[:version]}-macos-#{architecture}.dmg"
  raise "Wrong release URL" unless values[:url] == expected
  raise "Invalid SHA256" unless /\A[0-9a-f]{64}\z/.match?(values.fetch(:sha256))
  raise "Missing macOS restriction" unless values[:depends_on] == :macos
  raise "Wrong app artifact" unless values[:app] == "Entropy.app"
  raise "Wrong homepage" unless values[:homepage] == "https://github.com/ergohaven/entropy"
  puts "PASS #{architecture}: pinned release URL, SHA256 format, app and homepage"
end
