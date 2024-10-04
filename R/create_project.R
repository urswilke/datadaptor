#' Create Mapping directory structure from template folder
#'
#' @param proj_path The path of your new mapping project.
#' @param proj_template_path The template folder path; the first word should be the project leader initials.
#' @param proj_folder_name The project folder name (defaults to the path name `proj_template_path` without parent directories).
#' @param proj_name The project folder name with the project leader initials removed.
#' @param proj_leader First word in `proj_template_path`.
#' @param use_rproj Whether to create an Rstudio Rproj.
#' @param use_renv Whether to use renv.
#' @param use_git Whether to setup git.
#' @param open_mapping Whether to open the Excel mapping file.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' proj_path <- "PATH/WHERE/TO/CREATE/THE/NEW/MAPPING/UW My Project Name"
#' create_mapping_project(proj_path)
#' }
create_mapping_project <- function(proj_path,
                                   proj_template_path = "K:/Tools/TableBook/202308/Template Folder/",
                                   mapping_subpath = "Syntax/Mapping.xlsm",
                                   proj_folder_name = proj_path |>
                                     stringr::str_remove("/$") |>
                                     stringr::str_remove(".*/"),
                                   proj_name = proj_folder_name |> stringr::word(2, -1),
                                   proj_leader = stringr::word(proj_folder_name),
                                   use_rproj = TRUE,
                                   use_renv = TRUE,
                                   use_git = TRUE,
                                   open_mapping = TRUE
                                   ) {
  mapping_template_path <- file.path(proj_path, mapping_subpath)

  fs::dir_copy(proj_template_path, proj_path)

  mapping_proj_path <- stringr::str_replace(mapping_template_path, "\\.xlsm", paste0(" ", proj_name, ".xlsm"))
  fs::file_move(mapping_template_path, mapping_proj_path)
  if (open_mapping) {
    utils::browseURL(mapping_proj_path)
  }

  if (use_rproj) {
    # adapted from here:
    # https://www.danieldsjoberg.com/starter/articles/create_project.html#metadata
    starter_template <- list(
      # uncomment to include readme:
      # readme = rlang::expr(list(
      #   template_filename = system.file("project_templates/default_readme.md", package = "starter"),
      #   filename = "README.md",
      #   glue = TRUE
      # )),
      rproj = rlang::expr(list(
        template_filename = system.file("project_templates/default_rproj.Rproj", package = "starter"),
        filename = glue::glue("{folder_name}.Rproj"),
        glue = FALSE
      )),
      gitignore = rlang::expr(list(
        template_filename = system.file("project-templates/default_gitignore.txt", package = "datenanpassr"),
        filename = ".gitignore",
        glue = TRUE
      ))
    )

    starter::create_project(proj_path,
                            template = starter_template,
                            git = use_git,
                            renv = use_renv,
                            open = TRUE)
    if (use_renv) {
      renv::activate(proj_path)
      renv::snapshot(proj_path, packages = c("datenanpassr", "crosstabser"), prompt = FALSE, force = TRUE)
      renv::deactivate(proj_path)
    }
    cli::cli_alert_success("In your new Rstudio project type `usethis::use_git()` to commit the files.")

  }
}
