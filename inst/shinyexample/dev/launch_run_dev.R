## Using golemLaunch object
golem::detach_all_attached()
golem::document_and_reload()

# You can choose your run_dev if choose = TRUE
my_app <- golemLaunch$new()

# More actions
my_app$show_terminal()
my_app$open_app()

# my_app$stop()