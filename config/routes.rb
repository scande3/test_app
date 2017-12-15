Rails.application.routes.draw do
  # This will generate "/test" at http://localhost:3002/v2/test
  mount TestEngine::Engine => '/'

  # This will generate "/v2/local/test" at http://localhost:3002/v2/mount/test2
  mount TestEngine2::Engine => '/mount'
end
