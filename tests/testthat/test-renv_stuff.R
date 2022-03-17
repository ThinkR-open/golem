test_that("add_dockerfiles_renv all output file are present", {
  skip_if_not_installed("dockerfiler", "0.1.4")
  
  
  
  with_dir(pkg, {
    for (fun in list(N
      add_dockerfile_with_renv,
      add_dockerfile_with_renv_shinyproxy
    )) {

            # deploy_folder <-  file.path(tempdir(),make.names(paste0("deploy",round(runif(1,min = 0,max = 99999)))))
            deploy_folder <-  file.path(tempdir(),"deploy2")
            fun(output_dir = deploy_folder)

          expect_exists(file.path(deploy_folder,"Dockerfile"))
          expect_exists(file.path(deploy_folder,"Dockerfile_socle"))
          expect_exists(file.path(deploy_folder,"README"))
          expect_exists(file.path(deploy_folder,"renv.lock.prod"))
          
          list.files(path = deploy_folder,pattern = "tar.gz$")
          

    }
  })
})