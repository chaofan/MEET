require 'spec_helper'

describe "admin_roles/show.html.erb" do
  before(:each) do
    @role = assign(:role, stub_model(Admin::Role,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should contain("Name".to_s)
  end
end
