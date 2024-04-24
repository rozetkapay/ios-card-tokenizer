Pod::Spec.new do |s|
  s.name             = 'RozetkaPayTokenizer'
  s.version          = '1.0.0'
  s.summary          = 'RozetkaPayTokenizer helps you get a token for a bank card through RozetkaPay Payment Provider.'
  s.description      = "RozetkaPayTokenizer provides a simple interface to get a token for a payment card, that your users specify. This token will further be used when working with other RozetkaPay services."

  s.homepage         = 'https://rozetkapay.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'RozetkaPay' => 'rozetkapay.com' }
  s.source           = { :git => 'https://github.com/rozetkapay/ios-card-tokenizer.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'RozetkaPayTokenizer/**/*.{h,m,swift}'
  s.swift_versions = ['5.0', '5.1']
end
