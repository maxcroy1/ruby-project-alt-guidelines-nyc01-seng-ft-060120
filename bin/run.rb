require_relative '../config/environment'

controller_instance = Controller.new()
logged_in_user = controller_instance.greeting()

until !logged_in_user.nil?
    sleep 2
    system "clear"
    theUserChoice = controller_instance.greetings()
end

controller_instance.user = logged_in_user

controller_instance.main_menu
