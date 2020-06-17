require_relative '../config/environment'

#Instantiate new controller or session instance
controller_instance = Controller.new()
#Set logged_in_user to the user that will login or register
logged_in_user = controller_instance.greeting()

#Until a user is logged in, stay in this loop
if !logged_in_user.nil?
    system "clear"
    #Set current user to the user instance that is logged in
    controller_instance.user = logged_in_user
    #Begin the session at the main menu
    controller_instance.main_menu
end





