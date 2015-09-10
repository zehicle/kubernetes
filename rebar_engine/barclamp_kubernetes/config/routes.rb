# Copyright 2015, RackN
#

BarclampKubernetes::Engine.routes.draw do

  # API routes
  scope :defaults => {:format=> 'json'} do
    constraints( :api_version => /v[1-9]/ ) do
      scope ':api_version' do

        resources :barclamps do
          collection do
            get :catalog
          end
          member do
          end
        end
      end
    end
  end

  # non-API routes
  resources :barclamps do
    collection do
    end
    member do
    end
  end


# configure routes for these Kubernetes barclamps controller actions...
# (other controllers may also need routing configuration!)
#
# initialize

end
