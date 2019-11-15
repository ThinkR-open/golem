test_that("config works", {
  with_dir(pkg, {
    expect_equal(get_golem_name(), fakename)
    expect_equal(get_golem_version(), "0.0.0.9000")
    expect_equal(get_golem_wd(), pkg)
    amend_golem_config(
      key = "where", 
      value = "indev"
    )
    amend_golem_config(
      key = "where", 
      value = "inprod", 
      config = "production"
    )
    pkgload::load_all()
    expect_equal(get_golem_config("where"), "indev")
    expect_equal(get_golem_config("where", config = "production"), "inprod")
    where_conf <- withr::with_envvar(
      c("R_CONFIG_ACTIVE" = "production"), {
        get_golem_config("where")
      }
    )
    expect_equal(where_conf, "inprod")
    set_golem_name("plop")
    expect_equal(get_golem_name(), "plop")
    set_golem_name(fakename)
    set_golem_version("0.0.0.9001")
    expect_equal(get_golem_version(), "0.0.0.9001")
    set_golem_version("0.0.0.9000")
    
    set_golem_wd(normalizePath("inst"))
    expect_equal(get_golem_wd(), normalizePath("inst"))
    set_golem_wd(pkg)
  })
})
