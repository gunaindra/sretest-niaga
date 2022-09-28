# frozen_string_literal: true

if defined?(ChefSpec)
  ChefSpec.define_matcher(:openssl_installation)

  def create_openssl_installation(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:openssl_installation, :create, resource)
  end
end
