require 'test_helper'

class SharedCellTest < Cell::TestCase
  test "header" do
    invoke :header
    assert_select "p"
  end
  
  test "footer" do
    invoke :footer
    assert_select "p"
  end
  
  test "admin_panel" do
    invoke :admin_panel
    assert_select "p"
  end
  
  test "nav_menu" do
    invoke :nav_menu
    assert_select "p"
  end
  

end
