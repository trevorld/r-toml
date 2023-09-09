desc "Build files for packaging"
task :default do
    sh 'Rscript -e "devtools::document()"'
    sh 'Rscript -e "knitr::knit(\"README.Rmd\")"'
    sh 'pandoc -o README.html README.md'
    sh 'Rscript -e "pkgdown::build_site()"'
end

desc "Test using toml-test suit"
task :toml_test do
  # sh './toml-test-v1.3.0-linux-amd64 exec/toml-test-decoder.r'
  sh './toml-test-v1.3.0-linux-amd64 -encoder exec/toml-test-encoder.r'
end
