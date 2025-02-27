require "test_helper"

describe DriversController do
  let (:driver) {
    Driver.create name: "sample driver", vin: "333333333"
  }
  
  describe "index" do
    it "gives back a successful response when drivers saved" do
      get drivers_path
      must_respond_with :success
    end
    
    it "can get to the root path" do
      get drivers_path
      must_respond_with :success
    end
  end
  
  describe "show" do
    it "responds with success when showing an existing valid driver" do
      get driver_path(driver.id)
      must_respond_with :success
    end
    
    it "responds with 404 with an invalid driver id" do
      get driver_path(-1)
      must_respond_with :not_found
    end
  end
  
  describe "new" do
    it "responds with success" do
      get new_driver_path
      must_respond_with :success
    end
  end
  
  describe "create" do
    it "can create a new driver with valid information accurately, and redirect" do
      driver_hash= {
        driver:{
          name: "sample driver",
          vin: "4560HAPPY"
        }
      }
      
      expect {
        post drivers_path, params: driver_hash
      }.must_change "Driver.count", 1
      
      new_driver = Driver.find_by(name: driver_hash[:driver][:name])
      expect(new_driver.vin).must_equal(driver_hash[:driver][:vin])
    end
    
    it "does not create a driver if the form data violates Driver validations, and responds with a redirect" do
      get driver_path(-1)
      must_respond_with :not_found
    end
  end
  
  describe "edit" do
    it "responds with success when getting the edit page for an existing, valid driver" do
      get edit_driver_path(driver.id)
      must_respond_with :success
    end
    
    it "responds with redirect when getting the edit page for a non-existing driver" do
      get edit_driver_path(-1)
      must_respond_with :not_found
    end
  end
  
  describe "update" do
    it "can update an existing driver with valid information accurately, and redirect" do
      new_driver = Driver.create(name: "new driver", vin: "44444444")
      
      updated_driver_form_data = {
        driver:{
          name: "sample driver",
          vin: "4560HAPPY"
        }
      }
      expect {
        patch driver_path(new_driver.id), params: updated_driver_form_data
      }.wont_change 'Driver.count'
      
      expect(Driver.find_by(id: new_driver.id).name).must_equal "sample driver"
      expect(Driver.find_by(id: new_driver.id).vin).must_equal "4560HAPPY"
    end
    
    it "does not update any driver if given an invalid id, and responds with a 404" do
      get driver_path(-1)
      must_respond_with :not_found
    end
    
    it "does not create a driver if the form data violates Driver validations, and responds with a redirect" do  
      new_driver = Driver.create(name: "sample driver", vin: "4560HAPPYSUN")
      
      bad_driver_form_data = {
        driver: {
          name: "",
          vin: ""
        }
      }
      
      patch driver_path(new_driver.id), params: bad_driver_form_data
      
      expect(Driver.find_by(id: new_driver.id).name).must_equal "sample driver"
      expect(Driver.find_by(id: new_driver.id).vin).must_equal "4560HAPPYSUN"
    end
  end
  
  describe "destroy" do
    it "destroys the driver instance in db when driver exists, then redirects" do
      new_driver = Driver.create(name: "new driver", vin: "44444444")
      
      expect {
        delete driver_path(new_driver.id)
      }.must_change "Driver.count", -1
    end
  end
end
