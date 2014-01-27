require 'spec_helper'


module FreePbx
  describe CdrsController do
    describe "routing" do
    
      it "Routes the root to the PbxUser Controller's index action" do
        { get: '/' }.should route_to(controller: 'free_pbx/cdrs', action: 'index')
      end

      it "routes to #index" do
        { get: '/cdrs' }.should route_to(controller: 'free_pbx/cdrs', action: 'index')
      end

      it "does not route to #new" do
        { get: "/cdrs/new" }.should_not be_routable
      end

    end


    describe "http response" do
      describe "GET #index" do
        xit "responds successfully with an HTTP 200 status code" do
          get :index
          expect(response).to be_success
          expect(response.code).to eq(200)
        end
      end
    end


  
  end
end

=begin
module FreePbx
  describe CdrsController do
  
    describe "GET 'index'" do
      it "returns http success" do
        get 'index'
        response.should be_success
      end
    end
  
  end
end
=end
