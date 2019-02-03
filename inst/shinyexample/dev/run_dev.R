# Install the package
devtools::install(".", upgrade = "never")

# Set to prod or to dev
options(golem.app.prod = TRUE) 

# Run the app
run_app()
