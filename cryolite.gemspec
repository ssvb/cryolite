Gem::Specification.new do |spec|
  spec.name          = "cryolite"
  spec.version       = "0.2.0"
  spec.authors       = ["Siarhiej Siamaška"]
  spec.email         = ["siarhei.siamashka@gmail.com"]

  spec.summary       = "Crystal language compatibility"
  spec.homepage      = "https://github.com/ssvb/cryolite"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*", "src/*", "LICENSE", "README.md"]
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 3.0.0"
end
